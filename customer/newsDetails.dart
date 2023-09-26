import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sewak/component/customerDrawer.dart';
import 'package:sewak/component/drawer.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sewak/owner/crud/modal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomerNewsDetail extends StatefulWidget {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String date;

  CustomerNewsDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
  });

  @override
  State<CustomerNewsDetail> createState() => _CustomerNewsDetailState();
}

class _CustomerNewsDetailState extends State<CustomerNewsDetail> {
  bool isLoading = false;
  File? file;
  ImagePicker image = ImagePicker();
  var url;

  @override
  getImage() async {
    print("Seerccccccc");
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });

    print(file);
  }

  @override
  Widget build(BuildContext context) {
    // DateTime datecreated = widget.date.toDate();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Sewak Nepal',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blueAccent,
          // Add an app logo or icon here
          // leading: Image.asset('assets/app_icon.png'),
        ),
        drawer: CustomerDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.newspaper),
                      label: Text(
                        'News',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange, // Change button color
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.calendar_today),
                      color: Colors.blue, // Change icon color
                    ),
                    Text(
                      'Published on: ' + widget.date,
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey, // Change text color
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Image(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
