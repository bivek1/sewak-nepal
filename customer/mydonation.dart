import 'package:flutter/material.dart';
import 'package:sewak/component/customerDrawer.dart';

class MyProfileCustomer extends StatefulWidget {
  const MyProfileCustomer({super.key});

  @override
  State<MyProfileCustomer> createState() => _MyProfileCustomerState();
}

class _MyProfileCustomerState extends State<MyProfileCustomer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:
            AppBar(title: Text('Profile'), backgroundColor: Colors.blueAccent),
        drawer: CustomerDrawer(),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text("My Donation")
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
