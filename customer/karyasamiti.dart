import 'package:flutter/material.dart';
import 'package:sewak/component/customerDrawer.dart';
import 'package:sewak/component/drawer.dart';
import 'package:sewak/owner/crud/modal.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
// import 'package:sewak/owner/crud/updateKaryasamiti.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomerKaryasamiti extends StatefulWidget {
  const CustomerKaryasamiti({super.key});

  @override
  State<CustomerKaryasamiti> createState() => _CustomerKaryasamitiState();
}

class _CustomerKaryasamitiState extends State<CustomerKaryasamiti> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text('Karyasamiti'), backgroundColor: Colors.blueAccent),
        drawer: CustomerDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            // Add other widgets above the StreamBuild
            Text(
              "Karyasamiti",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 14.0),
            //   child: TextField(
            //     controller: searchController,
            //     decoration: InputDecoration(
            //       hintText: 'Search by title',
            //       prefixIcon: Icon(Icons.search),
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(10.0),
            //       ),
            //     ),
            //     onChanged: (value) {
            //       setState(() {
            //         searchQuery = value;
            //       });
            //     },
            //   ),
            // ),

            Divider(),
            Expanded(
              child: KaryasamitiList(searchQuery: searchQuery),
            ),
          ]),
        ),
      ),
    );
  }
}

class KaryasamitiList extends StatefulWidget {
  final String searchQuery;

  const KaryasamitiList({required this.searchQuery});

  @override
  State<KaryasamitiList> createState() => _KaryasamitiListState();
}

class _KaryasamitiListState extends State<KaryasamitiList> {
  TextEditingController searchController = TextEditingController();
  // List<QueryDocumentSnapshot> searchedMembers = [];
  List<dynamic> searchedMembers = [];
  void initState() {
    super.initState();
    fetchData();
  }

  bool isLoading = true;

  Future<void> fetchData() async {
    // Replace with your API endpoint
    final response =
        await http.get(Uri.parse('https://sewak.watnepal.com/api-karyasamiti'));

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
    // Get the current date and time

    return Column(
      children: [
        isLoading // Check if data is still loading
            ? CircularProgressIndicator() // Show loading indicator
            : Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                  ),
                  itemCount: searchedMembers.length,
                  itemBuilder: (BuildContext context, int index) {
                    final createdAt =
                        DateTime.parse(searchedMembers[index]['joined_date']);
                    final formattedCreatedAt = getFormattedDateTime(createdAt);
                    return Card(
                      elevation:
                          5, // Add some elevation for a card-like appearance
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Karasamiti info"),
                                content: Container(
                                  height: 330,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        // height: 200,
                                        width: double
                                            .infinity, // Set width to full width
                                        child: searchedMembers[index]
                                                    ['image'] !=
                                                null
                                            ? Image(
                                                height: 140,
                                                image: NetworkImage(
                                                  searchedMembers[index]
                                                      ['image'],
                                                ),
                                                fit: BoxFit
                                                    .cover, // You can use BoxFit.cover here if needed
                                              )
                                            : Container(
                                                height: 140,
                                                child: Center(
                                                    child: Text(
                                                  "No Image Available",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 120,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    truncateWords(
                                                        searchedMembers[index]
                                                            ['name'],
                                                        5),
                                                    // children['name'],
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Divider(),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text("Post: "),
                                                      Text(
                                                          searchedMembers[index]
                                                                  ['post']
                                                              .toString())
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text("Number "),
                                                      Text(
                                                          searchedMembers[index]
                                                                  ['number']
                                                              .toString())
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text('Blood Group'),
                                                      Text(
                                                          searchedMembers[index]
                                                              ['blood'])
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 14,
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_month,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Joined date: " +
                                                      formattedCreatedAt,
                                                  style: TextStyle(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 73, 73, 73)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll<Color>(
                                                Colors.blueGrey)),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Close'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // height: 200,
                              width: double.infinity, // Set width to full width
                              child: searchedMembers[index]['image'] != null
                                  ? Image(
                                      height: 100,
                                      image: NetworkImage(
                                        searchedMembers[index]['image'],
                                      ),
                                      fit: BoxFit
                                          .cover, // You can use BoxFit.cover here if needed
                                    )
                                  : Container(
                                      height: 100,
                                      child: Center(
                                          child: Text(
                                        "No Image Available",
                                        style: TextStyle(color: Colors.grey),
                                      ))),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 40,
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Text(
                                            truncateWords(
                                                searchedMembers[index]['name'],
                                                5),
                                            // karyasamiti['name'],
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
      ],
    );
  }

  String truncateWords(String input, int maxWords) {
    List<String> words = input.split(' ');

    if (words.length <= maxWords) {
      return input;
    } else {
      List<String> truncatedWords = words.sublist(0, maxWords);
      return truncatedWords.join(' ') + '...';
    }
  }
}
