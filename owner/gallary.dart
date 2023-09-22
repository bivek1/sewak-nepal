import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:sewak/component/drawer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sewak/owner/crud/modal.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MyGallary extends StatefulWidget {
  const MyGallary({super.key});

  @override
  State<MyGallary> createState() => _MyGallaryState();
}

class _MyGallaryState extends State<MyGallary> {
  File? file;
  ImagePicker image = ImagePicker();
  var url;
  late DatabaseReference dbRef;
  // Generate a unique filename based on a timestamp and file extension
  String generateUniqueFileName(File file) {
    // Get the current timestamp
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    // Extract the file extension from the original file path
    String fileExtension = file.path.split('.').last;

    // Combine the timestamp and file extension to create a unique filename
    String uniqueFileName = '$timestamp.$fileExtension';

    return uniqueFileName;
  }

  getImage() async {
    print("Seerccccccc");
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
    String fileName = generateUniqueFileName(file!);

    print(file);
    createImage(name: "$fileName");
  }

  uploadFile(fileName) async {
    print('i am trying to be best');
    try {
      // Generate a unique filename for the uploaded image
      // String fileName = generateUniqueFileName(file!);
      var imagefile =
          FirebaseStorage.instance.ref().child("image").child("/$fileName.jpg");
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

  Future createImage({required String name}) async {
    try {
      uploadFile(name);
    } catch (e) {
      print(e);
    }

    print('sending-data');
    final docUser = FirebaseFirestore.instance.collection('photo').doc();
    // uploadFile();
    final photos = ImageModel(
      id: docUser.id,
      url: url,
    );
    final json = photos.toJson();
    await docUser.set(json).whenComplete(() => () {
          final snackBar = SnackBar(
            content: Text('Successfully Uploaded Photo in Gallary'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
  }

  // DatabaseReference? dbRef;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text('Photo Gallary'), backgroundColor: Colors.blueAccent),
        drawer: MyDrawer(),
        body: Column(children: [
          // Add other widgets above the StreamBuilder
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                  onPressed: () async {
                    getImage();
                  },
                  icon: Icon(Icons.photo_filter),
                  label: Text('Add New Image'))),
          Divider(),
          Expanded(
            child: PhotoList(key: UniqueKey()),
          ),
        ]),
      ),
    );
  }
}

class PhotoList extends StatefulWidget {
  const PhotoList({super.key});

  @override
  State<PhotoList> createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  int _currentIndex = 0;
  @override
  Future<void> deleteImage(String imagePath) async {
    try {
      // Construct the full path to the image in Firebase Storage
      String fullImagePath = 'image/2F1693972809139.png.jpg';

      // Delete the image from Firebase Storage
      final ref = FirebaseStorage.instance.ref().child(fullImagePath);
      await ref.delete();
      print('Image deleted successfully.');

      // Delete the document from Firestore
      await FirebaseFirestore.instance
          .collection('photo')
          .doc(imagePath)
          .delete();
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  Widget build(BuildContext context) {
    // Get the current date and time

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('photo').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No photo added.');
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 8.0, // Cross-axis spacing
            mainAxisSpacing: 8.0, // Main-axis spacing
          ),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var news = snapshot.data!.docs[index];
            String newsId = news.id;
            final currentDateTime = DateTime.now();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5,

                // Add some elevation for a card-like appearance
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhotoViewGallery.builder(
                            itemCount: snapshot.data!.docs.length,
                            builder: (context, index) {
                              var news = snapshot.data!.docs[index];
                              return PhotoViewGalleryPageOptions(
                                imageProvider: NetworkImage(news['url']),
                                minScale: PhotoViewComputedScale.contained,
                                maxScale: PhotoViewComputedScale.covered * 2,
                              );
                            },
                            backgroundDecoration: BoxDecoration(
                              color: Colors.black,
                            ),
                            scrollPhysics: BouncingScrollPhysics(),
                            pageController: PageController(initialPage: index),
                            onPageChanged: (index) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Image(
                          image: NetworkImage(
                            news['url'],
                          ),
                          fit: BoxFit.cover,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              deleteImage(newsId);
                            },
                            child: Text("Delete"))
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
