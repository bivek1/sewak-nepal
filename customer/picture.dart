import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sewak/component/customerDrawer.dart';

class Picture extends StatefulWidget {
  const Picture({Key? key}) : super(key: key);

  @override
  _PictureState createState() => _PictureState();
}

class _PictureState extends State<Picture> {
  late Future<List<Map<String, dynamic>>> photoList;

  @override
  void initState() {
    super.initState();
    photoList = fetchPhotos();
  }

  Future<List<Map<String, dynamic>>> fetchPhotos() async {
    final apiUrl = 'https://sewak.watnepal.com/api-photo';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load photos');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Gallery")),
        drawer: CustomerDrawer(),
        body: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: photoList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No photos available.'));
                  } else {
                    return PhotoGrid(photos: snapshot.data!);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhotoGrid extends StatelessWidget {
  final List<Map<String, dynamic>> photos;

  const PhotoGrid({required this.photos});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 8.0, // Cross-axis spacing
        mainAxisSpacing: 8.0, // Main-axis spacing
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        final imageUrl = photo['image'];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PhotoViewGallery.builder(
                  itemCount: photos.length,
                  builder: (context, index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(imageUrl),
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 2,
                    );
                  },
                  backgroundDecoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  scrollPhysics: BouncingScrollPhysics(),
                  pageController: PageController(initialPage: index),
                ),
              ),
            );
          },
          child: Card(
            elevation: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
