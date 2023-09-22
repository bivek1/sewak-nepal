import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sewak/component/drawer.dart';
import 'package:sewak/owner/crud/modal.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MyAdmin extends StatefulWidget {
  const MyAdmin({super.key});

  @override
  State<MyAdmin> createState() => _MyAdminState();
}

class _MyAdminState extends State<MyAdmin> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text('Admin List'), backgroundColor: Colors.blueAccent),
        drawer: MyDrawer(),
        body: AdminListView(key: UniqueKey()),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, 'addAdmin');
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

class AdminListView extends StatefulWidget {
  const AdminListView({super.key});

  @override
  State<AdminListView> createState() => _AdminListViewState();
}

class _AdminListViewState extends State<AdminListView> {
  bool isLoading = false;
  // File? file;
  ImagePicker image = ImagePicker();
  // var image_path;

  Future<void> _deleteAdmin(String adminId) async {
    try {
      await FirebaseFirestore.instance.collection('user').doc(adminId).delete();
    } catch (e) {
      print('Error deleting User: $e');
    }
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, String adminId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Admin'),
          content: Text('Are you sure you want to delete this admin?'),
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
                await _deleteAdmin(adminId);
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
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('user')
          .where('user_type', isEqualTo: 'admin')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No admins found.');
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var admin = snapshot.data!.docs[index];
            String adminId = admin.id;

            return ListTile(
              // trailing:
              title: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  width: 500,
                  // padding: EdgeInsets.all(10.00),
                  decoration: BoxDecoration(
                    color: Colors.white, // White background color
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: Offset(0, 4), // Offset of the shadow
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.people_alt_rounded),
                                  label: Text(admin['email']),
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Color.fromARGB(255, 35, 221, 19))),
                                ),
                                Text('Number: ' + admin['number'].toString()),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton.icon(
                                          onPressed: () {
                                            _showEditAdminBottomSheet(
                                                context,
                                                adminId,
                                                admin['number'].toString(),
                                                admin['email']);
                                          },
                                          icon: Icon(Icons.edit_document),
                                          label: Text('Edit')),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      ElevatedButton.icon(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(
                                              Colors
                                                  .redAccent, // Set your desired background color
                                            ),
                                          ),
                                          onPressed: () {
                                            _showDeleteConfirmation(
                                                context, adminId);
                                          },
                                          icon: Icon(Icons.delete),
                                          label: Text('Delete')),
                                    ])
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // subtitle: title: Text(admin.name),

              onTap: () {},
            );
          },
        );
      },
    );
  }

  void _showEditAdminBottomSheet(
    BuildContext context,
    String adminId,
    String numberM,
    String emailM,
  ) {
    TextEditingController number = TextEditingController(text: numberM);

    TextEditingController email = TextEditingController(text: emailM);
    TextEditingController joindDate = TextEditingController();

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Update Admin',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Admin Phone number* ",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: number,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade50,
                              filled: true,
                              hintText: '984187292',
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
                      Container(
                        child: TextField(
                          controller: email,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade50,
                              filled: true,
                              hintText: 'Email Address',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      isLoading = true;
                      await FirebaseFirestore.instance
                          .collection('user')
                          .doc(adminId)
                          .update({
                        'number': int.parse(number.text),
                        'email': email.text,
                      });
                      setState(() {
                        isLoading = false;
                      });

                      Navigator.pop(context);
                    },
                    child: isLoading
                        ? CircularProgressIndicator()
                        : Text('Update Admin'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
