import 'package:flutter/material.dart';
import 'package:sewak/component/drawer.dart';

class UpdateVolunteer extends StatefulWidget {
  const UpdateVolunteer({super.key});

  @override
  State<UpdateVolunteer> createState() => _UpdateVolunteerState();
}

class _UpdateVolunteerState extends State<UpdateVolunteer> {
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
            "Update Volunteer",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }
}
