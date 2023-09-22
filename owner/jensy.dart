import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:sewak/component/drawer.dart';
import 'package:sewak/owner/crud/modal.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MyJensy extends StatefulWidget {
  const MyJensy({super.key});

  @override
  State<MyJensy> createState() => _MyJensyState();
}

class _MyJensyState extends State<MyJensy> {
  TextEditingController _from = TextEditingController();
  TextEditingController _to = TextEditingController();
  // DateTime? _selectedfrom;
  // DateTime? _selectedto;
  String searchQuery = '';
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _from.text = DateFormat('yyyy-MM-dd').format(picked);
      });
  }

  Future<void> _selectTo(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _to.text = DateFormat('yyyy-MM-dd').format(picked);
      });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text('Jensy Donation List'),
            backgroundColor: Colors.blueAccent),
        drawer: MyDrawer(),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("From"),
                        TextFormField(
                          controller: _from,
                          readOnly: true, // Prevent manual input
                          decoration: InputDecoration(
                            labelText: 'Select Date',
                            suffixIcon: GestureDetector(
                              onTap: () => _selectDate(context),
                              child: Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("To"),
                        TextFormField(
                          controller: _to,
                          readOnly: true, // Prevent manual input
                          decoration: InputDecoration(
                            labelText: 'Select Date',
                            suffixIcon: GestureDetector(
                              onTap: () => _selectTo(context),
                              child: Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.00, left: 16.00),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.search),
                      label: Text('Filter')),
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: JennsyList(key: UniqueKey()),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, 'addJensy');
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

class JennsyList extends StatefulWidget {
  const JennsyList({super.key});

  @override
  State<JennsyList> createState() => _JennsyListState();
}

class _JennsyListState extends State<JennsyList> {
  @override
  Widget build(BuildContext context) {
    // Get the current date and time

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('jennsy').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No jennsy added');
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var donation = snapshot.data!.docs[index];
            String donationId = donation.id;
            final currentDateTime = DateTime.now();

            // Format the current date and time using intl package's DateFormat
            final formattedDateTime =
                DateFormat('yyyy-MM-dd').format(currentDateTime);

            return ListTile(
              // trailing:
              title: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Donated by " +
                              donation['first_name'] +
                              " " +
                              donation['last_name']),
                          content: Container(
                            height: 150,
                            child: Column(
                              children: [
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.calendar_month),
                                    Text(
                                      formattedDateTime,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.money_off_csred),
                                    Text(
                                      donation['jennsy'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.phone_android),
                                    Text(
                                      donation['number'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                )
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
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // White background color
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Shadow color
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 4), // Offset of the shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image(
                                  image: AssetImage('images/jensy.png'),
                                  height: 30,
                                  width: 30,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            donation['first_name'] +
                                                " " +
                                                donation['last_name'],
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),

                                          // Text("Number: " +
                                          //     donation['number'].toString()),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.savings),
                                Text(
                                  donation['jennsy'],
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // subtitle: title: Text(member.name),

              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => Updatedonation(
                //       id: donation['id'],
                //       title: donation['title'],
                //       description: donation['description'],
                //       imageUrl: donation['url'],
                //       date: donation['date'],
                //     ),
                //   ),
                // );
              },
            );
          },
        );
      },
    );
  }
}
