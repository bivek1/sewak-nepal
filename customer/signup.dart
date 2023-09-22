import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:sewak/services/auth_services.dart';

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
  TextEditingController number = TextEditingController();
  TextEditingController password = TextEditingController();
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
                      child: TextField(
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: 'First Name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5))),
                        controller: fullname,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      padding: EdgeInsets.only(
                          left: 20.00, right: 20.00, top: 20.00),
                      child: TextField(
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: 'Last Name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5))),
                        controller: lastname,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 20.00, right: 20.00, top: 20.00),
                  child: TextField(
                    decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                    controller: email,
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 20.00, right: 20.00, top: 20.00),
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Phone Number',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                    controller: number,
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 20.00, right: 20.00, top: 20.00),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                    controller: password,
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
                              await AuthServices().registerUserInFirebase(
                                  email.text,
                                  password.text,
                                  number.text,
                                  'member',
                                  context);

                              await AuthServices().registermember(fullname.text,
                                  lastname.text, email.text, number.text);
                              fullname.clear();
                              lastname.clear();
                              number.clear();
                              email.clear();
                              password.clear();
                              setState(() {
                                showLoading = false;
                              });
                            }

                            // Navigator.pushNamed(context, 'number');
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
