import 'package:flutter/material.dart';
import 'package:sewak/component/drawer.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sewak/component/drawer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sewak/owner/crud/modal.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  File? file;
  ImagePicker image = ImagePicker();
  var url;
  TextEditingController event_title = TextEditingController();
  TextEditingController event_image = TextEditingController();
  // TextEditingController event_type = TextEditingController();
  TextEditingController description = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text('Sewak Nepal'), backgroundColor: Colors.blueAccent),
        drawer: MyDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Container(
              //   color: Color.fromARGB(255, 234, 234, 234),
              //   child: ButtonBar(
              //     alignment: MainAxisAlignment.start,
              //     children: [
              //       TextButton(
              //           onPressed: () {
              //             Navigator.pushNamed(context, 'dashboard');
              //           },
              //           child: Text('Dashboard')),
              //       Icon(Icons.arrow_right_alt_rounded),
              //       TextButton(
              //           onPressed: () {
              //             Navigator.pushNamed(context, 'event');
              //           },
              //           child: Text('event and Event')),
              //       Icon(Icons.arrow_right_alt_rounded),
              //       TextButton(onPressed: () {}, child: Text('Add'))
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  padding: EdgeInsets.all(10.00),
                  // color: Color.fromARGB(255, 239, 239, 239),
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
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image(
                              image: AssetImage('images/news.png'),
                              height: 50,
                              width: 50,
                            ),
                            Text(
                              "Add event",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        height: 30,
                      ),
                      // Container(
                      //     height: 200,
                      //     width: 200,
                      //     child: file == null
                      //         ? IconButton(
                      //             icon: Icon(
                      //               Icons.add_a_photo,
                      //               size: 90,
                      //               color: Color.fromARGB(255, 0, 0, 0),
                      //             ),
                      //             onPressed: () {
                      //               getImage();
                      //             },
                      //           )
                      //         : MaterialButton(
                      //             height: 100,
                      //             child: Image.file(
                      //               file!,
                      //               fit: BoxFit.fill,
                      //             ),
                      //             onPressed: () {
                      //               getImage();
                      //             },
                      //           )),
                      Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(5)),
                          child: file == null
                              ? IconButton(
                                  icon: Icon(
                                    Icons.add_a_photo,
                                    size: 90,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  onPressed: () {
                                    getImage();
                                  },
                                )
                              : MaterialButton(
                                  height: 100,
                                  child: Image.file(
                                    file!,
                                    fit: BoxFit.fill,
                                  ),
                                  onPressed: () {
                                    getImage();
                                  },
                                )),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "News Title* ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        child: TextField(
                          controller: event_title,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade50,
                              filled: true,
                              hintText: 'Title of event',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Describe event* ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
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
                            controller: description,
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade50,
                              filled: true,
                              hintText: 'Describe your event.... ',
                              border: InputBorder.none,
                              //  OutlineInputBorder(
                              //     borderRadius: BorderRadius.circular(5),
                              //     borderSide: BorderSide(
                              //         color: Colors.grey,
                              //         width: 2,
                              //         style: BorderStyle.solid))
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            createEvent(name: event_title.text);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: isLoading
                                ? CircularProgressIndicator()
                                : Text('Add Event'),
                          )),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future createEvent({required String name}) async {
    try {
      uploadFile();
    } catch (e) {
      print(e);
    }

    print('sending-data');
    final docUser = FirebaseFirestore.instance.collection('event').doc();
    // uploadFile();
    final members = Event(
        id: docUser.id,
        title: event_title.text,
        description: description.text,
        url: url,
        date: '');
    final json = members.toJson();
    await docUser.set(json).whenComplete(() {
      Navigator.pushNamed(context, 'event');
      setState(() {
        isLoading = false;
      });
    });
  }

  getImage() async {
    print("Seerccccccc");
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });

    print(file);
  }

  uploadFile() async {
    print('i am trying to be best');
    try {
      var imagefile = FirebaseStorage.instance
          .ref()
          .child("image")
          .child("/${event_title.text}.jpg");
      UploadTask task = imagefile.putFile(file!);
      TaskSnapshot snapshot = await task;
      url = await snapshot.ref.getDownloadURL();
      setState(() {
        url = url;
      });
    } on Exception catch (e) {
      print(e);
    }
  }
}
