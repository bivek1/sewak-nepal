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

class AddNews extends StatefulWidget {
  const AddNews({super.key});

  @override
  State<AddNews> createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {
  File? file;
  ImagePicker image = ImagePicker();
  var url;
  TextEditingController news_title = TextEditingController();
  TextEditingController news_image = TextEditingController();
  // TextEditingController news_type = TextEditingController();
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              "Add News",
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
                      Center(
                        child: Text(
                          "Add News Image*",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Container(
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
                      ),
                      SizedBox(
                        height: 30,
                      ),
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
                          controller: news_title,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade50,
                              filled: true,
                              hintText: 'Title of News',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
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
                            controller: description,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade50,
                                filled: true,
                                hintText: 'Describe your news.... ',
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: ElevatedButton(
                            onPressed: () async {
                              createNews(name: news_title.text);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: isLoading
                                  ? CircularProgressIndicator()
                                  : Text('Add News'),
                            )),
                      ),
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

  Future createNews({required String name}) async {
    if (news_title.text.isEmpty || description.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Please enter all data'),
            content: Text('Make sure you have added all news data.'),
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
        isLoading = true;
      });
      try {
        var imagefile = FirebaseStorage.instance
            .ref()
            .child("image")
            .child("/${news_title.text}.jpg");
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
    print('sending-data');
    final docUser = FirebaseFirestore.instance.collection('news').doc();
    // uploadFile();
    final members = News(
      // id: docUser.id,
      title: news_title.text,
      description: description.text,
      url: url,
    );
    final json = members.toJson();
    await docUser.set(json).whenComplete(() {
      Navigator.pushNamed(context, 'news');
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
}
