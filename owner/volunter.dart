import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

class MyVolunteer extends StatefulWidget {
  const MyVolunteer({super.key});

  @override
  State<MyVolunteer> createState() => _MyVolunteerState();
}

class _MyVolunteerState extends State<MyVolunteer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text('Volunteers'), backgroundColor: Colors.blueAccent),
        drawer: MyDrawer(),
        body: VolunteerListView(key: UniqueKey()),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, 'addVolunter');
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

class VolunteerListView extends StatefulWidget {
  const VolunteerListView({super.key});

  @override
  State<VolunteerListView> createState() => _VolunteerListViewState();
}

class _VolunteerListViewState extends State<VolunteerListView> {
  bool isLoading = false;

  // File? file;
  ImagePicker image = ImagePicker();
  List<dynamic> searchedMembers = [];
  // var image_path;

  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> _deleteVolunteer(int volunteerId) async {
    // try {
    //   await FirebaseFirestore.instance
    //       .collection('volunteer')
    //       .doc(volunteerId)
    //       .delete();
    // } catch (e) {
    //   print('Error deleting volunteer: $e');
    // }
  }

  Future<void> fetchData() async {
    // Replace with your API endpoint
    final response =
        await http.get(Uri.parse('https://sewak.watnepal.com/api-volunteers'));

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

  String getFormattedDateTime(DateTime dateTime) {
    final formattedDateTime = DateFormat('yyyy-MM-dd').format(dateTime);
    return formattedDateTime;
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, int volunteerId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete volunteer'),
          content: Text('Are you sure you want to delete this volunteer?'),
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
                await _deleteVolunteer(volunteerId);
                Navigator.of(context).pop();
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
        var volunteer = searchedMembers[index]['id'];
        int volunteerId = volunteer;

        return ListTile(
          // trailing:
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
                          child:
                              searchedMembers[index]['image'].toString().isEmpty
                                  ? CircleAvatar(
                                      backgroundImage:
                                          AssetImage('images/logo.png'),
                                      radius: 40,
                                    )
                                  : Image(
                                      image: NetworkImage(
                                          searchedMembers[index]['profil_pic']),
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
                                Text(
                                  searchedMembers[index]['first_name'] +
                                      " " +
                                      searchedMembers[index]['last_name'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text('Phone: ' +
                                searchedMembers[index]['number'].toString()),
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
                                      _showEditvolunteerBottomSheet(
                                        context,
                                        volunteerId,
                                        searchedMembers[index]['first_name'],
                                        searchedMembers[index]['last_name'],
                                        searchedMembers[index]['number']
                                            .toString(),
                                        searchedMembers[index]['email'],
                                        searchedMembers[index]['address'],
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
                                          context, volunteerId);
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

          // Padding(
          //   padding: const EdgeInsets.only(top: 10.0),
          //   child: Container(
          //     width: 500,
          //     // padding: EdgeInsets.all(10.00),
          //     decoration: BoxDecoration(
          //       color: Colors.white, // White background color
          //       borderRadius: BorderRadius.circular(5),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.grey.withOpacity(0.5), // Shadow color
          //           spreadRadius: 5,
          //           blurRadius: 5,
          //           offset: Offset(0, 4), // Offset of the shadow
          //         ),
          //       ],
          //     ),
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         Row(
          //           children: [
          //             // Image(
          //             //   width: 100,
          //             //   image: NetworkImage(volunteer['url']),
          //             //   fit: BoxFit.cover,
          //             // ),
          //             // SizedBox(
          //             //   width: 10,
          //             // ),
          //             Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   ElevatedButton.icon(
          //                     onPressed: () {},
          //                     icon: Icon(Icons.people_alt_rounded),
          //                     label: Text(volunteer['first_name'] +
          //                         " " +
          //                         volunteer['last_name']),
          //                     style: ButtonStyle(
          //                         backgroundColor: MaterialStatePropertyAll(
          //                             Color.fromARGB(255, 10, 222, 77))),
          //                   ),
          //                   Text('Number: ' +
          //                       volunteer['number'].toString()),
          //                   Text(
          //                     'Email: ' + volunteer['email'],
          //                     // Set the maximum number of lines
          //                     overflow: TextOverflow.ellipsis,
          //                   ),
          //                   Row(
          //                       mainAxisAlignment: MainAxisAlignment.center,
          //                       children: [
          //                         ElevatedButton.icon(
          //                             onPressed: () {
          //                               _showEditvolunteerBottomSheet(
          //                                 context,
          //                                 volunteerId,
          //                                 volunteer['first_name'],
          //                                 volunteer['last_name'],
          //                                 volunteer['number'].toString(),
          //                                 volunteer['email'],
          //                                 volunteer['address'],
          //                               );
          //                             },
          //                             icon: Icon(Icons.edit_document),
          //                             label: Text('Edit')),
          //                         SizedBox(
          //                           width: 20,
          //                         ),
          //                         ElevatedButton.icon(
          //                             style: ButtonStyle(
          //                               backgroundColor:
          //                                   MaterialStateProperty.all<
          //                                       Color>(
          //                                 Colors
          //                                     .redAccent, // Set your desired background color
          //                               ),
          //                             ),
          //                             onPressed: () {
          //                               _showDeleteConfirmation(
          //                                   context, volunteerId);
          //                             },
          //                             icon: Icon(Icons.delete),
          //                             label: Text('Delete')),
          //                       ])
          //                 ],
          //               ),
          //             )
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // subtitle: title: Text(volunteer.name),

          onTap: () {},
        );
      },
    );
  }

  void _showEditvolunteerBottomSheet(
    BuildContext context,
    int volunteerId,
    String first_name,
    String last_name,
    String numberM,
    String emailM,
    String addressM,
  ) {
    TextEditingController firstName = TextEditingController(text: first_name);
    TextEditingController lastName = TextEditingController(text: last_name);
    TextEditingController number = TextEditingController(text: numberM);
    TextEditingController address = TextEditingController(text: addressM);
    TextEditingController email = TextEditingController(text: emailM);
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image(
                          image: AssetImage('images/volunter.png'),
                          height: 70,
                          width: 70,
                        ),
                        Text(
                          "Add Volunteer",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(
                      height: 15,
                    ),
                    Divider(),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "First Name*",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .4,
                              child: TextField(
                                controller: firstName,
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade50,
                                    filled: true,
                                    hintText: 'First Name',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Last Name*",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .4,
                              child: TextField(
                                controller: lastName,
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade50,
                                    filled: true,
                                    hintText: 'Last Name',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Phone Number*",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: TextField(
                            controller: number,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade50,
                                filled: true,
                                hintText: '981878171',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email Address*",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: TextField(
                            controller: email,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade50,
                                filled: true,
                                hintText: 'email@watnepal.com',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Address*",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: TextField(
                            controller: address,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade50,
                                filled: true,
                                hintText: 'Address',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton.icon(
                        onPressed: () async {
                          isLoading = true;
                          // await FirebaseFirestore.instance
                          //     .collection('volunteer')
                          //     .doc(volunteerId)
                          //     .update({
                          //   'first_name': firstName.text,
                          //   'last_name': lastName.text,
                          //   'address': address.text,
                          //   'number': int.parse(number.text),
                          //   'email': email.text,
                          // });
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.edit),
                        label: Text('Update Volunteer')),
                    SizedBox(
                      height: 10,
                    )
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
