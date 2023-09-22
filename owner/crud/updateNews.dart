import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sewak/component/drawer.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sewak/owner/crud/modal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateNews extends StatefulWidget {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String date;

  UpdateNews({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
  });

  @override
  State<UpdateNews> createState() => _UpdateNewsState();
}

class _UpdateNewsState extends State<UpdateNews> {
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

  // uploadFile(title) async {
  //   print('i am trying to be best');
  //   try {
  //     var imagefile =
  //         FirebaseStorage.instance.ref().child("image").child("/$title}.jpg");
  //     UploadTask task = imagefile.putFile(file!);
  //     TaskSnapshot snapshot = await task;
  //     url = await snapshot.ref.getDownloadURL();
  //     setState(() {
  //       url = url;
  //     });
  //   } on Exception catch (e) {
  //     print(e);
  //   }
  //   return url;
  // }

  Future<void> _deleteMember(int newsid) async {
    // try {
    //   await FirebaseFirestore.instance
    //       .collection('news')
    //       .doc(newsid)
    //       .delete()
    //       .whenComplete(() => Navigator.pushNamed(context, 'news'));
    // } catch (e) {
    //   print('Error deleting member: $e');
    // }
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, int memberId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete News'),
          content: Text('Are you sure you want to delete this news?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                // await _deleteMember(widget.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
        drawer: MyDrawer(),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _showEditMemberBottomSheet(
                          context,
                          widget.id,
                          widget.title,
                          widget.description,
                          widget.imageUrl,
                        );
                      },
                      icon: Icon(Icons.edit_document),
                      label: Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green, // Change button color
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        _showDeleteConfirmation(context, widget.id);
                      },
                      icon: Icon(Icons.delete),
                      label: Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent, // Change button color
                      ),
                    ),
                  ],
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

  void _showEditMemberBottomSheet(
    BuildContext context,
    int id,
    String title,
    String description,
    String imageUrl,
  ) {
    TextEditingController titleText = TextEditingController(text: title);
    TextEditingController descriptionText =
        TextEditingController(text: description);

    // TextEditingController joindDate = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Update News',
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                    ),
                    Divider(),
                    SizedBox(
                      height: 20,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          decoration: imageUrl.isEmpty
                              ? BoxDecoration(border: Border.all())
                              : BoxDecoration(),
                          alignment: Alignment.center,
                          child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: imageUrl.isEmpty
                                  ? Center(
                                      child: file == null
                                          ? IconButton(
                                              icon: Icon(
                                                Icons.add_a_photo,
                                                size: 50,
                                                color: Color.fromARGB(
                                                    255, 5, 128, 173),
                                              ),
                                              onPressed: () {
                                                getImage();
                                              },
                                            )
                                          : Image.file(file!),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        getImage();
                                      },
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(imageUrl),
                                        radius: 70,
                                      ))),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "News Title* ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          child: TextField(
                            controller: titleText,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade50,
                                filled: true,
                                hintText: 'Title of News',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "News Description* ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Container(
                          height: 140,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: TextField(
                              maxLines: null,
                              controller: descriptionText,
                              decoration: InputDecoration(
                                  fillColor: Colors.grey.shade50,
                                  filled: true,
                                  hintText: 'Describe your news.... ',
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton.icon(
                        onPressed: () async {
                          // try {
                          //   uploadFile(titleText.text);
                          // } catch (e) {
                          //   print(e);
                          // }
                          // String imageU = "";
                          // try {
                          //   String imageU = await uploadFile(titleText.text);
                          // } catch (e) {
                          //   String imageU = "";
                          // }
                          print("See this message");
                          print(file);
                          print(url);
                          setState(() {
                            isLoading = true;
                          });
                          final members = News(
                            // id: '1',
                            title: widget.title,
                            description: widget.description,
                            url: url,
                          );
                          final json = members.toJson();

                          final apiUrl =
                              'https://sewak.watnepal.com/api-News/'; // Replace with your API endpoint
                          final response = await http.put(Uri.parse(apiUrl),
                              headers: {
                                'Content-Type':
                                    'application/json', // Set the appropriate content type
                              },
                              body: json);

                          if (response.statusCode == 200) {
                            // Data updated successfully
                            print('Data updated successfully');
                          } else {
                            // Handle errors, e.g., show an error message
                            print(
                                'Failed to update data: ${response.statusCode}');
                          }

                          // await FirebaseFirestore.instance
                          //     .collection('news')
                          //     .doc(id)
                          //     .update({
                          //   'title': titleText.text,
                          //   'description': descriptionText.text,
                          //   'url': imageU.isEmpty ? imageUrl : imageU
                          // }).whenComplete(() => {
                          //           Navigator.pop(context),
                          //           Navigator.pushNamed(context, 'news')
                          //         });
                        },
                        icon: isLoading
                            ? CircularProgressIndicator()
                            : Icon(Icons.add),
                        label: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Update News'),
                        ))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
//   }
  }
}
