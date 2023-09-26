import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sewak/component/drawer.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sewak/owner/memberCash.dart';
import 'package:sewak/owner/memberJennsy.dart';

class MemberDetailScreen extends StatefulWidget {
  final int id;
  final String name;
  final String number;
  final String imageUrl;
  final String email;
  final String address;
  final String blood;

  MemberDetailScreen({
    required this.id,
    required this.name,
    required this.number,
    required this.imageUrl,
    required this.address,
    required this.email,
    required this.blood,
  });

  @override
  State<MemberDetailScreen> createState() => _MemberDetailScreenState();
}

class MemberDonation {
  final String donationType;
  final double amount;
  final String jennsy;
  final String remarks;
  DateTime date;

  MemberDonation(
      {required this.donationType,
      required this.amount,
      required this.jennsy,
      required this.remarks,
      required this.date});
}

class _MemberDetailScreenState extends State<MemberDetailScreen> {
  File? file;
  ImagePicker image = ImagePicker();
  var url;
  DateTime? selectedDonationDate;
  TextEditingController donated = TextEditingController();
  TextEditingController remarks = TextEditingController();

  DateTime? selectedDonationDateJennsy;
  TextEditingController donatedJennsy = TextEditingController();
  TextEditingController remarksJennsy = TextEditingController();
  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }

  uploadFile() async {
    // try {
    //   var imagefile = FirebaseStorage.instance
    //       .ref()
    //       .child("image")
    //       .child("/${widget.name}.jpg");
    //   UploadTask task = imagefile.putFile(file!);
    //   TaskSnapshot snapshot = await task;
    //   url = await snapshot.ref.getDownloadURL();
    //   setState(() {
    //     url = url;
    //   });
    // } on Exception catch (e) {
    //   print(e);
    // }
    // await FirebaseFirestore.instance
    //     .collection('member')
    //     .doc(widget.id)
    //     .update({
    //   'url': url,
    // }).whenComplete(() => {Navigator.pushNamed(context, 'member')});
  }

  TextEditingController _from = TextEditingController();
  TextEditingController _to = TextEditingController();
  // DateTime? _selectedfrom;
  // DateTime? _selectedto;
  String searchQuery = '';
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDonationDateJennsy = picked;
        _from.text = DateFormat('yyyy-MM-dd').format(picked);
      });
  }

  Future<void> _selectTo(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDonationDate = picked;
        _to.text = DateFormat('yyyy-MM-dd').format(picked);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Member Detail'),
        backgroundColor: Colors.blue,
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 185, 223, 255),
                    const Color.fromARGB(255, 99, 156, 255)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: '${widget.imageUrl}' == null
                            ? BoxDecoration(border: Border.all())
                            : BoxDecoration(),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: file == null
                              ? Center(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.add_a_photo,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      getImage();
                                    },
                                  ),
                                )
                              : Center(
                                  child: MaterialButton(
                                    height: 10,
                                    child: Image.file(
                                      file!,
                                      // fit: BoxFit.fill,
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                        ),
                      ),
                      file == null
                          ? '${widget.imageUrl}'.isEmpty
                              ? Container(
                                  width: 200,
                                  height: 200,
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Center(
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add_a_photo,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          getImage();
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    getImage();
                                  },
                                  child: Container(
                                      child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(widget.imageUrl),
                                    radius: 100,
                                  )),
                                )
                          : Positioned(
                              bottom: 20,
                              child: file == null
                                  ? Text("")
                                  : ElevatedButton.icon(
                                      onPressed: () {
                                        uploadFile();
                                      },
                                      icon: Icon(Icons.change_circle),
                                      label: Text('Change Image')),
                            ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${widget.name}',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                        child: Icon(Icons.phone_android,
                            color: const Color.fromARGB(255, 255, 255, 255))),
                    title: Container(
                      padding: EdgeInsets.all(8.00),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.lightBlueAccent),
                      // color: Colors.amberAccent,
                      child: Text(
                        '${widget.number}',
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                        child: Icon(Icons.email_rounded,
                            color: const Color.fromARGB(255, 255, 255, 255))),
                    title: Container(
                      padding: EdgeInsets.all(8.00),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.lightBlueAccent),
                      // color: Colors.amberAccent,
                      child: Text(
                        '${widget.email}',
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                        child: Icon(Icons.location_city,
                            color: const Color.fromARGB(255, 254, 254, 254))),
                    title: Container(
                      padding: EdgeInsets.all(8.00),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.lightBlueAccent),
                      // color: Colors.amberAccent,
                      child: Text(
                        '${widget.address}',
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                        child: Icon(Icons.bloodtype,
                            color: const Color.fromARGB(255, 254, 254, 254))),
                    title: Container(
                      padding: EdgeInsets.all(8.00),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.lightBlueAccent),
                      // color: Colors.amberAccent,
                      child: Text(
                        '${widget.blood}',
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DashboardBox(
                  icon: Icon(Icons.gif_box, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => JennsyDonationPage(
                                  memberId: widget.id,
                                )));
                  },
                  title: 'Jennsy',
                ),
                DashboardBox(
                  icon: Icon(Icons.money, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CashDonationPage(
                                  memberId: widget.id,
                                )));
                  },
                  title: 'Cash',
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Donation',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          showDonateDialog();
                        },
                        icon: Icon(Icons.post_add_rounded),
                        label: Text("Add New"),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.redAccent)),
                      )
                    ],
                  ),
                  Divider(),

                  SizedBox(
                    height: 20,
                  ),
                  // Display member donations here
                  // StreamBuilder<QuerySnapshot>(
                  //   stream: FirebaseFirestore.instance
                  //       .collection('memberDonation')
                  //       .where('memberId', isEqualTo: widget.id)
                  //       // .orderBy('date', descending: true)
                  //       // .orderBy('timestamp', descending: true)
                  //       .snapshots(),
                  //   builder: (context, snapshot) {
                  //     if (!snapshot.hasData) {
                  //       return CircularProgressIndicator();
                  //     }
                  //     final donations = snapshot.data!.docs;
                  //     List<Widget> donationWidgets = [];
                  //     for (var donation in donations) {
                  //       final donationData =
                  //           donation.data() as Map<String, dynamic>;
                  //       final donationType = donationData['donationType'];
                  //       final amount = donationData['amount'];
                  //       final remarks = donationData['remarks'];
                  //       final date = donationData['date'];
                  //       DateTime donateDate = date.toDate();
                  //       String formattedDate =
                  //           DateFormat('yyyy-MM-dd').format(donateDate);
                  //       // Create a widget to display each donation
                  //       Widget donationWidget = ListTile(
                  //         title: Text(''),
                  //         subtitle: Container(
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(8),
                  //             color: Colors.white, // White background color
                  //             boxShadow: [
                  //               BoxShadow(
                  //                 color: Colors.grey
                  //                     .withOpacity(0.5), // Shadow color
                  //                 spreadRadius: 5,
                  //                 blurRadius: 10,
                  //                 offset: Offset(0, 4), // Offset of the shadow
                  //               ),
                  //             ],
                  //           ),
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Center(
                  //               child: Column(
                  //                 children: [
                  //                   Row(
                  //                     mainAxisAlignment:
                  //                         MainAxisAlignment.spaceBetween,
                  //                     children: [
                  //                       Image(
                  //                         image: donationType == 'jennsy'
                  //                             ? AssetImage('images/jensy.png')
                  //                             : AssetImage('images/donate.png'),
                  //                         height: 30,
                  //                         width: 30,
                  //                       ),
                  //                       Column(
                  //                         mainAxisAlignment:
                  //                             MainAxisAlignment.end,
                  //                         crossAxisAlignment:
                  //                             CrossAxisAlignment.end,
                  //                         children: [
                  //                           SizedBox(
                  //                             width: 5,
                  //                           ),
                  //                           Padding(
                  //                             padding:
                  //                                 const EdgeInsets.all(8.0),
                  //                             child: Column(
                  //                               crossAxisAlignment:
                  //                                   CrossAxisAlignment.start,
                  //                               children: [
                  //                                 Text(
                  //                                   donationType == 'cash'
                  //                                       ? "Rs. " +
                  //                                           donation['amount']
                  //                                               .toString()
                  //                                       : donation['jennsy'],
                  //                                   style: TextStyle(
                  //                                       fontSize: 20,
                  //                                       fontWeight:
                  //                                           FontWeight.w500),
                  //                                 ),
                  //                                 Divider(),
                  //                                 Text(
                  //                                   "Remarks: " +
                  //                                       donation['remarks'],
                  //                                   style: TextStyle(
                  //                                       fontWeight:
                  //                                           FontWeight.w400),
                  //                                 )
                  //                                 // Text("Number: " +
                  //                                 //     donation['donated'].toString()),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   Divider(),
                  //                   Row(
                  //                     mainAxisAlignment:
                  //                         MainAxisAlignment.spaceBetween,
                  //                     crossAxisAlignment:
                  //                         CrossAxisAlignment.center,
                  //                     children: [
                  //                       Row(children: [
                  //                         Icon(Icons.date_range),
                  //                         SizedBox(
                  //                           width: 5,
                  //                         ),
                  //                         // Text(formattedDateTime)
                  //                       ]),
                  //                       SizedBox(
                  //                         width: 10,
                  //                       ),
                  //                       Text(
                  //                         formattedDate,
                  //                         style: TextStyle(
                  //                             fontWeight: FontWeight.bold),
                  //                       )
                  //                     ],
                  //                   )
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //       donationWidgets.add(donationWidget);
                  //     }

                  //     return Column(
                  //       children: donationWidgets,
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
            // Add your recent donation list here
          ],
        ),
      ),
    );
  }

  void showDonateDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(''),
          content: SingleChildScrollView(
            child: Container(
              height: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Choose the type of donation"),
                  Divider(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            // Navigator.of(context).pop();
                            // showDonateDialog();
                          },
                          icon: Icon(Icons.money_outlined),
                          label: Text('नगत'),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.redAccent)),
                        ),
                        ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                              showJennsyDialog();
                            },
                            icon: Icon(Icons.money_outlined),
                            label: Text('Jennsy'))
                      ]),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Donated Rs*",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: donated,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade50,
                              filled: true,
                              hintText: 'Donated Rs..',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Donated Date*",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _to,
                          readOnly: true, // Prevent manual input
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            labelText: 'Select Date',
                            suffixIcon: GestureDetector(
                              onTap: () => _selectTo(context),
                              child: Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Remarks*",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: remarks,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade50,
                              filled: true,
                              hintText: 'Remarks',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Add Donation",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                          onPressed: () {
                            addDonation();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back'),
            ),
          ],
        );
      },
    );
  }

  void addDonation() async {
    if (donated.text.isEmpty ||
        remarks.text.isEmpty ||
        _to.toString().isEmpty) {
      // Create and show a SnackBar
      final snackBar = SnackBar(
        content: Text('Please add donation data'),
        duration: Duration(seconds: 3), // Adjust the duration as needed
        action: SnackBarAction(
          label: '',
          onPressed: () {
            // Add an action when the user clicks on it
            // You can put your custom action logic here
          },
        ),
      );

      // Show the SnackBar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      print("aa");
      try {
        // Create a new MemberDonation object
        final newDonation = MemberDonation(
            donationType: "cash", // You can change this based on user selection
            amount: double.parse(donated.text),
            jennsy: "",
            remarks: remarks.text,
            date: selectedDonationDate!);

        // Add the new donation to Firestore
        await FirebaseFirestore.instance.collection('memberDonation').add({
          'donationType': newDonation.donationType,
          'amount': newDonation.amount,
          'remarks': newDonation.remarks,
          'memberId': widget.id,
          'jennsy': "",
          'date': Timestamp.fromDate(
              selectedDonationDate!), // Link the donation to the member
        });

        donated.clear();
        _to.clear();
        remarks.clear();
        // Close the dialog
        Navigator.pop(context);
      } catch (e) {
        print(e);
      }
    }
  }

  void showJennsyDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(''),
          content: SingleChildScrollView(
            child: Container(
              height: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Choose the type of donation"),
                  Divider(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            showDonateDialog();
                          },
                          icon: Icon(Icons.money_outlined),
                          label: Text('नगत'),
                        ),
                        ElevatedButton.icon(
                            onPressed: () {},
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.redAccent)),
                            icon: Icon(Icons.money_outlined),
                            label: Text('Jennsy'))
                      ]),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Donated item*",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: donatedJennsy,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade50,
                              filled: true,
                              hintText: '3 Bag of rice',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Donated Date*",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _from,
                          readOnly: true, // Prevent manual input
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            labelText: 'Select Date',
                            suffixIcon: GestureDetector(
                              onTap: () => _selectDate(context),
                              child: Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Remarks*",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: remarksJennsy,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade50,
                              filled: true,
                              hintText: 'Remarks',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Add Jennsy",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                          onPressed: () {
                            addJennsy();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back'),
            ),
          ],
        );
      },
    );
  }

  void addJennsy() async {
    if (donatedJennsy.text.isEmpty ||
        remarksJennsy.text.isEmpty ||
        _from.toString().isEmpty) {
      // Create and show a SnackBar
      final snackBar = SnackBar(
        content: Text('Please add donation data'),
        duration: Duration(seconds: 3), // Adjust the duration as needed
        action: SnackBarAction(
          label: '',
          onPressed: () {
            // Add an action when the user clicks on it
            // You can put your custom action logic here
          },
        ),
      );

      // Show the SnackBar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      print("aa");
      try {
        // Create a new MemberDonation object
        final newDonation = MemberDonation(
            donationType:
                "jennsy", // You can change this based on user selection
            amount: 0.00,
            jennsy: donatedJennsy.text,
            remarks: remarksJennsy.text,
            date: selectedDonationDateJennsy!);

        // Add the new donation to Firestore
        await FirebaseFirestore.instance.collection('memberDonation').add({
          'donationType': newDonation.donationType,
          'amount': newDonation.amount,
          'remarks': newDonation.remarks,
          'memberId': widget.id,
          "jennsy": newDonation.jennsy,
          'date': Timestamp.fromDate(
              selectedDonationDateJennsy!), // Link the donation to the member
        });

        donatedJennsy.clear();
        _from.clear();
        remarksJennsy.clear();
        // Close the dialog
        Navigator.pop(context);
      } catch (e) {
        print(e);
      }
    }
  }

// Count Cash
}

// member donartion list

class DashboardBox extends StatelessWidget {
  final Icon icon;
  final String title;
  final VoidCallback onPressed;

  const DashboardBox({
    required this.icon,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 176,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 233, 233, 233).withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
