import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool showLoading = false;
  TextEditingController fullname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  // TextEditingController number = TextEditingController();
  TextEditingController password = TextEditingController();

  Future createUser({required String name}) async {
    print("name");
    print(name);
    if (fullname.text.isEmpty ||
        lastname.text.isEmpty ||
        // number.text.isEmpty ||
        // address.text.isEmpty ||
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
    } else {
      print("Adding new user");
      final response = await http.post(
        Uri.parse(
            'https://sewak.watnepal.com/api-register-member'), // Replace with your API endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'first_name': fullname.text,
          'last_name': lastname.text,
          'username': email.text,
          'email': email.text,
          'password': password.text,
          'user_type': 'customer', // Specify 'customer' as the user type
          'number': 123, // Replace with the customer's phone number
          'blood': " ", // Replace with the customer's blood type
          'address': " ", // Replace with the customer's address
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
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 251, 251),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 30,
                ),
                Image(
                  image: AssetImage('images/create.png'),
                  height: 200,
                  width: 200,
                ),
                Text(
                  "Sewak Nepal",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Create an account",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      padding: EdgeInsets.only(
                          left: 20.00, right: 20.00, top: 20.00),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "First Name*",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextField(
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: 'First Name',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            controller: fullname,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      padding: EdgeInsets.only(
                          left: 20.00, right: 20.00, top: 20.00),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Last Name*",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextField(
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: 'Last Name',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            controller: lastname,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 20.00, right: 20.00, top: 20.00),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email*",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5))),
                        controller: email,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 20.00, right: 20.00, top: 20.00),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Password*",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: 'Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5))),
                        controller: password,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15.00),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Create Now',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blueAccent,
                        child: IconButton(
                          color: Colors.white,
                          onPressed: () async {
                            if (fullname.text.isEmpty ||
                                email.text.isEmpty ||
                                password.text.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Details is required'),
                                    content: Text(
                                        'Your username and password is required'),
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
                              setState(() {
                                showLoading = true;
                              });
                              createUser(name: fullname.text);
                              setState(() {
                                showLoading = false;
                              });
                              Navigator.pushNamed(context, 'home');
                            }
                          },
                          icon: showLoading
                              ? CircularProgressIndicator()
                              : Icon(Icons.arrow_forward),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.00),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'home');
                          },
                          child: Text(
                            'Goto Login',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                      ]),
                )
              ],
            ),
          ),
        ));
  }
}
