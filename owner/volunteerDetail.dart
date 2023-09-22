import 'package:flutter/material.dart';
import 'package:sewak/component/drawer.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class VolunteerDetailScreen extends StatefulWidget {
  final String id;
  final String name;
  final String number;
  final String imageUrl;
  final String email;
  final String address;

  VolunteerDetailScreen({
    required this.id,
    required this.name,
    required this.number,
    required this.imageUrl,
    required this.address,
    required this.email,
  });

  @override
  State<VolunteerDetailScreen> createState() => _VolunteerDetailScreenState();
}

class _VolunteerDetailScreenState extends State<VolunteerDetailScreen> {
  File? file;
  ImagePicker image = ImagePicker();
  var url;

  getImage() async {
    print("Seerccccccc");
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });

    // print(file);
  }

  uploadFile() async {
    print('i am trying to be best');
    try {
      var imagefile = FirebaseStorage.instance
          .ref()
          .child("image")
          .child("/${widget.name}.jpg");
      UploadTask task = imagefile.putFile(file!);
      TaskSnapshot snapshot = await task;
      url = await snapshot.ref.getDownloadURL();
      setState(() {
        url = url;
      });
    } on Exception catch (e) {
      print(e);
    }
    await FirebaseFirestore.instance
        .collection('volunteer')
        .doc(widget.id)
        .update({
      'url': url,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteer Detail'),
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Color.fromARGB(255, 234, 234, 234),
              child: ButtonBar(
                alignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'dashboard');
                      },
                      child: Text('Dashboard')),
                  Icon(Icons.arrow_right_alt_rounded),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'member');
                      },
                      child: Text('Members')),
                  Icon(Icons.arrow_right_alt_rounded),
                  TextButton(onPressed: () {}, child: Text('Details'))
                ],
              ),
            ),
            SizedBox(
              height: 14,
            ),
            // Container(
            //     height: 130,
            //     child: file == null
            //         ? '${widget.imageUrl}'.isEmpty
            //             ? Center(
            //                 child: IconButton(
            //                   icon: Icon(
            //                     Icons.add_a_photo,
            //                     size: 50,
            //                     color: Color.fromARGB(255, 0, 0, 0),
            //                   ),
            //                   onPressed: () {
            //                     getImage();
            //                   },
            //                 ),
            //               )
            //             : CircleAvatar(
            //                 backgroundImage: NetworkImage(widget.imageUrl),
            //                 radius: 70,
            //               )
            //         : Center(
            //             child: MaterialButton(
            //               height: 30,
            //               child: Image.file(
            //                 file!,
            //                 fit: BoxFit.fill,
            //               ),
            //               onPressed: () {
            //                 getImage();
            //               },
            //             ),
            //           )),
            SizedBox(
              height: 20,
            ),
            Container(
              child: file == null
                  ? Text("")
                  : ElevatedButton.icon(
                      onPressed: () {
                        uploadFile();
                      },
                      icon: Icon(Icons.change_circle),
                      label: Text('Change Image')),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 30,
                ),
                Icon(Icons.people_alt_rounded),
                SizedBox(
                  width: 30,
                ),
                Text(
                  '${widget.name}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 30,
                ),
                Icon(Icons.phone_android),
                SizedBox(
                  width: 30,
                ),
                Text(
                  '${widget.number}',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 30,
                ),
                Icon(Icons.email_rounded),
                SizedBox(
                  width: 30,
                ),
                Text(
                  '${widget.email}',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 30,
                ),
                Icon(Icons.location_city),
                SizedBox(
                  width: 30,
                ),
                Text(
                  '${widget.address}',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DashboardBox(
                    icon: Icon(Icons.person_pin_circle_rounded),
                    onPressed: () {
                      Navigator.pushNamed(context, 'volunteer');
                    },
                    title: 'Volunteer \n 200'),
                DashboardBox(
                    icon: Icon(Icons.gif_box),
                    onPressed: () {
                      Navigator.pushNamed(context, 'donation');
                    },
                    title: 'Donation \n 292'),
              ],
            ),
            SizedBox(height: 20.0),
            Text(
              'Recent Donation',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardBox extends StatelessWidget {
  final Icon icon;
  final String title;
  final VoidCallback onPressed;

  const DashboardBox(
      {required this.icon, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 176,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 233, 233, 233).withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          height: 100,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: icon,
                  iconSize: 34,
                  color: Colors.blueAccent,
                  onPressed: () {},
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
