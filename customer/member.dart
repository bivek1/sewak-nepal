import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sewak/component/customerDrawer.dart';
import 'package:sewak/component/drawer.dart';
import 'package:sewak/owner/memberDetail.dart';
import 'package:sewak/owner/crud/modal.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  List<QueryDocumentSnapshot> searchedMembers = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('member').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No members found.'));
        }

        List<QueryDocumentSnapshot> filteredMembers =
            snapshot.data!.docs.where((member) {
          String fullName = member['first_name'] + ' ' + member['last_name'];
          String number = member['number'].toString();

          return fullName
                  .toLowerCase()
                  .contains(widget.searchQuery.toLowerCase()) ||
              number.contains(widget.searchQuery);
        }).toList();

        return ListView.builder(
          itemCount: filteredMembers.length,
          itemBuilder: (context, index) {
            var member = filteredMembers[index];
            String memberId = member.id;

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
                              child: member['url'].toString().isEmpty
                                  ? CircleAvatar(
                                      backgroundImage:
                                          AssetImage('images/logo.png'),
                                      radius: 40,
                                    )
                                  : Image(
                                      image: NetworkImage(member['url']),
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
                                      member['first_name'] +
                                          " " +
                                          member['last_name'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text('Phone: ' + member['number'].toString()),
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MemberDetailScreen(
                      id: member['id'],
                      name: member['first_name'] + " " + member['last_name'],
                      number: member['number'].toString(),
                      imageUrl: member['url'],
                      address: member['address'],
                      email: member['email'],
                      blood: member['blood'],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
