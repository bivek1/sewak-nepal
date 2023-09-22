import 'package:flutter/material.dart';
import 'package:sewak/component/drawer.dart';

class UpdateJensy extends StatefulWidget {
  const UpdateJensy({super.key});

  @override
  State<UpdateJensy> createState() => _UpdateJensyState();
}

class _UpdateJensyState extends State<UpdateJensy> {
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
            "Update Jensy",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }
}
