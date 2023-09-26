import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sewak/component/customerDrawer.dart';
import 'package:sewak/component/drawer.dart';
import 'package:sewak/customer/memberDetail.dart';

import 'package:sewak/owner/crud/modal.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sewak/owner/volunteerDetail.dart';

class CustomerMember extends StatefulWidget {
  const CustomerMember({Key? key});

  @override
  State<CustomerMember> createState() => _CustomerMemberState();
}

class _CustomerMemberState extends State<CustomerMember> {
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
        drawer: CustomerDrawer(),
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
                                child: member['profil_pic'] != null &&
                                        member['profil_pic'].isNotEmpty
                                    ? Image(
                                        image:
                                            NetworkImage(member['profil_pic']),
                                        fit: BoxFit.cover,
                                      )
                                    : CircleAvatar(
                                        backgroundImage:
                                            AssetImage('images/logo.png'),
                                        radius: 40,
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
                      builder: (context) => MemberDetailScreenC(
                          id: member['id'],
                          name: '$firstName $lastName',
                          // name: member['first_name'] + " " + member['last_name'],
                          number: member['number'].toString(),
                          imageUrl: member['profil_pic'],
                          address: member['address'],
                          email: "$email",
                          blood: member['blood'],
                          admin: member['admin']),
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
}
