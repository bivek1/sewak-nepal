import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:sewak/customer/dashboard.dart';
import 'package:sewak/customer/store.dart';
import 'package:sewak/main.dart';
import 'package:sewak/services/auth_services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool showLoading = false;
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> checklogin() async {
    final apiUrl = Uri.parse('https://sewak.watnepal.com/api-customuser');
    final response = await http.get(apiUrl);
    final userIdProvider = Provider.of<UserIdProvider>(context, listen: false);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      // Process and use the data as needed
      // For example, you can iterate through the list of products:
      for (var user in data) {
        if (user['username'] == _usernameController.text &&
            user['password'] == _passwordController.text) {
          if (user['user_type'] == "owner") {
            Navigator.pushNamed(context, 'dashboard');
          } else {
            print("The provider id");
            print(user['id']);
            userIdProvider.setUserId(user['id']);
            Navigator.pushNamed(context, 'customer');

            break;
          }
        } else {
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Incorrect email and password'),
                content: Text('Your email or password is incorrect'),
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
        }
        print('Product Name: ${user['first_name']}');
      }
    } else {
      // Handle API request error
      print('Failed to load data: ${response.statusCode}');
    }
  }

  void _login() async {
    // Check credentials (replace with your authentication logic)
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Please enter email and password'),
            content: Text('Email or Password can\'t be empty.'),
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
    } else if (_usernameController.text == 'bibek' &&
        _passwordController.text == "123456") {
      Navigator.pushNamed(context, 'dashboard');
    } else {
      setState(() {
        showLoading = true;
      });
      checklogin();

      setState(() {
        showLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(15), // Add border radius here
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Shadow color
                          spreadRadius: 5, // Spread radius
                          blurRadius: 7, // Blur radius
                          offset:
                              Offset(0, 3), // Offset in the x and y direction
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 80,
                        ),
                        Center(
                          child: Image(image: AssetImage('images/logo.png')),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Sewak Nepal",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Welcome again to login ",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
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
                              Container(
                                child: TextField(
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      hintText: 'Email Address',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Password*",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: TextField(
                                  obscureText: true,
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      hintText: 'Password',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: _login,
                          icon: showLoading
                              ? CircularProgressIndicator()
                              : Icon(Icons.login),
                          label: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Login'),
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  Colors.redAccent)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.00),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'register');
                                  },
                                  child: Text(
                                    'Create an account',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            Color.fromARGB(255, 102, 102, 102)),
                                  ),
                                ),
                                Text(
                                  'Forget password',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          Color.fromARGB(255, 102, 102, 102)),
                                ),
                              ]),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
