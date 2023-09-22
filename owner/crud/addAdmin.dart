import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:sewak/services/auth_services.dart';
import 'package:sewak/component/drawer.dart';

class AddAdmin extends StatefulWidget {
  const AddAdmin({super.key});

  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  bool showLoading = false;
  TextEditingController fullname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController password = TextEditingController();
  // DatabaseReference? dbRef;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text('Sewak Nepal'), backgroundColor: Colors.blueAccent),
        drawer: MyDrawer(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
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
                        offset: Offset(0, 3), // Offset in the x and y direction
                      ),
                    ],
                  ),
                  child: Column(children: [
                    SizedBox(
                      height: 20,
                    ),
                    Image(
                      image: AssetImage('images/admin.png'),
                      height: 200,
                      width: 200,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Add New Admin",
                      style: TextStyle(fontSize: 20),
                    ),
                    Divider(),
                    Container(
                      padding: EdgeInsets.only(
                          left: 20.00, right: 20.00, top: 20.00),
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
                      padding: EdgeInsets.only(
                          left: 20.00, right: 20.00, top: 20.00),
                      child: TextField(
                        keyboardType: TextInputType.number,
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
                      padding: EdgeInsets.only(
                          left: 20.00, right: 20.00, top: 20.00),
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
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton.icon(
                        onPressed: () async {
                          if (email.text.isEmpty || password.text.isEmpty) {
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
                                'admin',
                                context);

                            // await AuthServices().registeradmin(fullname.text,
                            //     lastname.text, email.text, number.text);

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
                            : Icon(Icons.admin_panel_settings_rounded),
                        label: Text("Add New Admin")),
                    SizedBox(
                      height: 20,
                    )
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
