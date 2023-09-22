import 'package:flutter/material.dart';
import 'package:sewak/component/datetime.dart';
import 'package:sewak/component/drawer.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sewak/component/drawer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sewak/owner/crud/modal.dart';

class AddJensy extends StatefulWidget {
  const AddJensy({super.key});

  @override
  State<AddJensy> createState() => _AddJensyState();
}

class _AddJensyState extends State<AddJensy> {
  bool isLoading = false;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController jennsy = TextEditingController();
  TextEditingController date = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text('Sewak Nepal'), backgroundColor: Colors.blueAccent),
        drawer: MyDrawer(),
        body: SingleChildScrollView(
          child: Container(
            child: Column(children: [
              // Container(
              //   color: Color.fromARGB(255, 234, 234, 234),
              //   child: ButtonBar(
              //     alignment: MainAxisAlignment.start,
              //     children: [
              //       TextButton(
              //           onPressed: () {
              //             Navigator.pushNamed(context, 'dashboard');
              //           },
              //           child: Text('Dashboard')),
              //       Icon(Icons.arrow_right_alt_rounded),
              //       TextButton(
              //           onPressed: () {
              //             Navigator.pushNamed(context, 'jensy');
              //           },
              //           child: Text('Jensy')),
              //       Icon(Icons.arrow_right_alt_rounded),
              //       TextButton(onPressed: () {}, child: Text('Add Donation'))
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  padding: EdgeInsets.all(10.00),
                  // color: Color.fromARGB(255, 239, 239, 239),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(15), // Add border radius here
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 5, // Spread radius
                        blurRadius: 7, // Blur radius
                        offset: Offset(0, 3), // Offset in the x and y direction
                      ),
                    ],
                  ),
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
                          Text(
                            "Add Jensy Donation",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Image(
                            image: AssetImage('images/jensy.png'),
                            height: 40,
                            width: 40,
                          ),
                        ],
                      ),
                      Divider(),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                width: 150,
                                child: TextField(
                                  controller: firstName,
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey.shade50,
                                      filled: true,
                                      hintText: 'Buddha',
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
                                width: 150,
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
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  fillColor: Colors.grey.shade50,
                                  filled: true,
                                  hintText: '9871217828',
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
                            "Jennsy Material*",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: TextField(
                              controller: jennsy,
                              decoration: InputDecoration(
                                  fillColor: Colors.grey.shade50,
                                  filled: true,
                                  hintText: 'Jensy Type',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5))),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: date,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade50,
                            filled: true,
                            hintText: 'Date',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5))),
                      ),
                      Container(
                          // child: DatePickerDialog(
                          //   initialDate: DateTime.now(),
                          //   firstDate: DateTime(2000),
                          //   lastDate: DateTime(2200),
                          // ),

                          ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            createJennsy(name: firstName.text);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text('Add Jensy Donation'),
                          )),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Future createJennsy({required String name}) async {
    if (firstName.text.isEmpty ||
        lastName.text.isEmpty ||
        number.text.isEmpty ||
        jennsy.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Please enter all data'),
            content: Text('Make sure you have added all donation data.'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      print('sending-data');
      final docUser = FirebaseFirestore.instance.collection('jennsy').doc();
      // uploadFile();
      final donations = Jennsy(
          id: docUser.id,
          first_name: firstName.text,
          last_name: lastName.text,
          number: number.text,
          jennsy: jennsy.text,
          date: '');
      final json = donations.toJson();
      await docUser.set(json).whenComplete(() {
        Navigator.pushNamed(context, 'jennsy');
        setState(() {
          isLoading = false;
        });
      });
    }
  }
}
