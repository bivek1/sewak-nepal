import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sewak/component/customerDrawer.dart';
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

class CustomerVolunteer extends StatefulWidget {
  const CustomerVolunteer({super.key});

  @override
  State<CustomerVolunteer> createState() => _CustomerVolunteerState();
}

class _CustomerVolunteerState extends State<CustomerVolunteer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text('Volunteers'), backgroundColor: Colors.blueAccent),
        drawer: CustomerDrawer(),
        body: VolunteerListView(key: UniqueKey()),
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          onTap: () {},
        );
      },
    );
  }
}
