import 'package:flutter/material.dart';
import 'package:sewak/component/drawer.dart';

class UpdateDonation extends StatefulWidget {
  const UpdateDonation({super.key});

  @override
  State<UpdateDonation> createState() => _UpdateDonationState();
}

class _UpdateDonationState extends State<UpdateDonation> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text('Sewak Nepal'), backgroundColor: Colors.blueAccent),
        drawer: MyDrawer(),
        body: Container(
          child: Center(
              child: Text(
            "Update Donation",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }
}
