import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sewak/component/drawer.dart';
import 'package:sewak/owner/memberDetail.dart';
import 'package:sewak/owner/crud/modal.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sewak/owner/volunteerDetail.dart';

class MyMember extends StatefulWidget {
  const MyMember({Key? key});

  @override
  State<MyMember> createState() => _MyMemberState();
}

class _MyMemberState extends State<MyMember> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sewak Nepal'),
          backgroundColor: Colors.blueAccent,
        ),
        drawer: MyDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name or number',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: MemberListView(searchQuery: searchQuery),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, 'addMember');
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

class MemberListView extends StatefulWidget {
  final String searchQuery;

  const MemberListView({required this.searchQuery});

  @override
  State<MemberListView> createState() => _MemberListViewState();
}

class _MemberListViewState extends State<MemberListView> {
  bool isLoading = false;
  ImagePicker image = ImagePicker();
  TextEditingController searchController = TextEditingController();
  List<dynamic> searchedMembers = [];
  Map<String, dynamic>? userData;
  void initState() {
    super.initState();
    fetchData();
  }

  Future<Map<String, String>> _fetchUserDetails(int userId) async {
    final apiUrl = 'https://sewak.watnepal.com/api-customuser-details/$userId';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final firstName = jsonData['first_name'] as String;
        final lastName = jsonData['last_name'] as String;
        final email = jsonData['username'] as String;
        print(email);
        return {'first_name': firstName, 'last_name': lastName};
      } else {
        throw Exception('Failed to load user details');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> fetchData() async {
    // Replace with your API endpoint
    final response =
        await http.get(Uri.parse('https://sewak.watnepal.com/api-customer'));

    if (response.statusCode == 200) {
      // Parse the JSON data here
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      // json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        searchedMembers =
            jsonData; // Update the searchedMembers with the fetched data
        isLoading = false; // Set loading to false when data is loaded
      });
      print(searchedMembers);
    } else {
      // Handle errors here
      print('Failed to load data: ${response.statusCode}');
      isLoading = false; // Set loading to false on error as well
    }
  }

  Future<void> _deleteMember(String memberId) async {
    try {
      await FirebaseFirestore.instance
          .collection('member')
          .doc(memberId)
          .delete();
    } catch (e) {
      print('Error deleting member: $e');
    }
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, int memberId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Member'),
          content: Text('Are you sure you want to delete this member?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                // await _deleteMember(memberId);
                // Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: searchedMembers.length,
      itemBuilder: (context, index) {
        return FutureBuilder<Map<String, String>>(
          future: _fetchUserDetails(searchedMembers[index]['admin']),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Display a loading indicator while fetching data.
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // Data fetched successfully
              var member = searchedMembers[index];
              int memberId = member['id'];
              final firstName = snapshot.data!['first_name'];
              final lastName = snapshot.data!['last_name'];
              final email = snapshot.data!['username'];

              return ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                                width: 100,
                                height: 120,
                                child: member['profil_pic'].toString().isEmpty
                                    ? CircleAvatar(
                                        backgroundImage:
                                            AssetImage('images/logo.png'),
                                        radius: 40,
                                      )
                                    : Image(
                                        image:
                                            NetworkImage(member['profil_pic']),
                                        fit: BoxFit.cover,
                                      )),
                            SizedBox(width: 20),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.supervised_user_circle_sharp),
                                      SizedBox(width: 10),
                                      Text('$firstName $lastName')
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text('Phone: ' + member['number'].toString()),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.blueAccent,
                                        child: IconButton(
                                          color: Colors.white,
                                          onPressed: () {
                                            _showEditMemberBottomSheet(
                                              context,
                                              memberId,
                                              member['first_name'],
                                              member['last_name'],
                                              member['number'].toString(),
                                              member['email'],
                                              member['address'],
                                              member['blood'],
                                              member['profil_pic'],
                                            );
                                          },
                                          icon: Icon(Icons.mode_edit),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor:
                                            Color.fromARGB(255, 227, 13, 13),
                                        child: IconButton(
                                          color: Colors.white,
                                          onPressed: () {
                                            _showDeleteConfirmation(
                                                context, memberId);
                                          },
                                          icon: Icon(Icons.delete),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MemberDetailScreen(
                        id: member['id'],
                        name: '$firstName $lastName',
                        // name: member['first_name'] + " " + member['last_name'],
                        number: member['number'].toString(),
                        imageUrl: member['profil_pic'],
                        address: member['address'],
                        email: "$email",
                        blood: member['blood'],
                      ),
                    ),
                  );
                },
              );
            }
          },
        );
      },
    );
  }

  void _showEditMemberBottomSheet(
    BuildContext context,
    int memberId,
    String first_name,
    String last_name,
    String numberM,
    String emailM,
    String bloodM,
    String addressM,
    String url,
  ) {
    TextEditingController firstName = TextEditingController(text: first_name);
    TextEditingController lastName = TextEditingController(text: last_name);
    TextEditingController number = TextEditingController(text: numberM);
    TextEditingController address = TextEditingController(text: addressM);
    TextEditingController email = TextEditingController(text: emailM);
    TextEditingController blood = TextEditingController(text: bloodM);
    TextEditingController joindDate = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Update Member',
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: url.toString().isEmpty
                          ? Center(child: Text('No Image Available'))
                          : CircleAvatar(
                              backgroundImage: NetworkImage(url),
                              radius: 60,
                            ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "First Name* ",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: firstName,
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade50,
                                    filled: true,
                                    hintText: 'Ram',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(),
                                      borderRadius: BorderRadius.circular(5),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Last Name*",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: lastName,
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade50,
                                    filled: true,
                                    hintText: 'Dhakal',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Number*",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            controller: number,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade50,
                                filled: true,
                                hintText: '98410910191',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email Address*",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: email,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade50,
                                filled: true,
                                hintText: 'ramdhakal@gmail.com',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Member Address*",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: address,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade50,
                                filled: true,
                                hintText: 'Bouddha, Kathmandu',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Blood Group*",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: blood,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade50,
                                filled: true,
                                hintText: 'B+',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton.icon(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });

                          // await FirebaseFirestore.instance
                          //     .collection('member')
                          //     .doc(memberId)
                          //     .update({
                          //   'first_name': firstName.text,
                          //   'last_name': lastName.text,
                          //   'address': address.text,
                          //   'number': int.parse(number.text),
                          //   'email': email.text,
                          //   'blood': blood.text
                          // }).whenComplete(() => () {
                          //           setState(() {
                          //             isLoading = false;
                          //           });
                          //         });
                          // Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all<Size>(
                            Size.fromHeight(
                                60.0), // Adjust the height as needed
                          ),
                        ),
                        icon: isLoading
                            ? CircularProgressIndicator()
                            : Icon(Icons.add),
                        label: Text('update member')),
                    // ElevatedButton(
                    //   onPressed: () async {},
                    //   child: isLoading
                    //       ? CircularProgressIndicator()
                    //       : Text('Update Member'),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
