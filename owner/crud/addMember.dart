import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sewak/component/drawer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sewak/owner/crud/modal.dart';

import 'package:intl/intl.dart';
// import 'package:sewak/owner/crud/updateKaryasamiti.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddMember extends StatefulWidget {
  const AddMember({super.key});

  @override
  State<AddMember> createState() => _AddMemberState();
}

// validator: (value) {
//   if (value == null || value.isEmpty) {
//     return 'Please enter an email';
//   }
//   return null;
// },

class _AddMemberState extends State<AddMember> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController blood = TextEditingController();
  TextEditingController joindDate = TextEditingController();
  File? file;
  ImagePicker image = ImagePicker();
  var url;
  late DatabaseReference dbRef;
  bool isLoading = false;
  // DatabaseReference? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('sewak-nepal');
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text('Sewak Nepal'), backgroundColor: Colors.blueAccent),
        drawer: MyDrawer(),
        body: SingleChildScrollView(
          child: Container(
            child: Column(children: [
              SizedBox(
                height: 15,
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
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image(
                              image: AssetImage('images/member.png'),
                              height: 50,
                              width: 50,
                            ),
                            Text(
                              "Add Member",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Add Member Image* ",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(5)),
                          child: file == null
                              ? IconButton(
                                  icon: Icon(
                                    Icons.add_a_photo,
                                    size: 90,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  onPressed: () {
                                    getImage();
                                  },
                                )
                              : MaterialButton(
                                  height: 100,
                                  child: Image.file(
                                    file!,
                                    fit: BoxFit.fill,
                                  ),
                                  onPressed: () {
                                    getImage();
                                  },
                                )),
                      SizedBox(
                        height: 50,
                      ),
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
                            final name = firstName.text;
                            createUser(name: name);
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
                          label: Text("Add Member")),
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

  Future createUser({required String name}) async {
    if (firstName.text.isEmpty ||
        lastName.text.isEmpty ||
        number.text.isEmpty ||
        address.text.isEmpty ||
        email.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Please enter all data'),
            content: Text('Make sure you have added all member data.'),
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
    } else if (file == null) {
      setState(() {
        isLoading = true;
      });

      final response = await http.post(
        Uri.parse(
            'https://sewak.watnepal.com/api-register-member'), // Replace with your API endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'username': email.text,
          'email': email.text,
          'password': '123456',
          'user_type': 'customer', // Specify 'customer' as the user type
          'number': number.text, // Replace with the customer's phone number
          'blood': blood.text, // Replace with the customer's blood type
          'address': address.text, // Replace with the customer's address
          'profile_pic': "",
          // You can include the profile picture as base64 data if needed
        }),
      );

      if (response.statusCode == 201) {
        // User registration successful
        print('Customer registered successfully');
      } else {
        // User registration failed
        print('Failed to register customer: ${response.body}');
      }
    } else {
      setState(() {
        isLoading = true;
      });

      String apiUrl =
          'https://sewak.watnepal.com/api-register-member'; // Replace with your API endpoint

      // Read the image file and convert it to base64
      List<int> imageBytes = await file!.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      Map<String, dynamic> requestBody = {
        'username': email.text,
        'email': email.text,
        'first_name': firstName.text,
        'last_name': lastName.text,
        'password': '123456',
        'user_type': 'customer', // Specify 'customer' as the user type
        'number': number.text, // Replace with the customer's phone number
        'blood': blood.text, // Replace with the customer's blood type
        'address': address.text, // Replace with the customer's address
        'profile_pic': base64Image
      };

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Failed to upload image:  ${response.body}');
      }
    }
  }

  getImage() async {
    print("Seerccccccc");
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });

    // print(file);
  }
}
