import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sewak/component/customerDrawer.dart';
import 'package:sewak/component/drawer.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:sewak/customer/memberDonation.dart';
import 'package:sewak/customer/memberJennsy.dart';
import 'package:sewak/owner/memberCash.dart';
import 'package:sewak/owner/memberJennsy.dart';

class MemberDetailScreenC extends StatefulWidget {
  final int id;
  final String name;
  final String number;
  final String imageUrl;
  final String email;
  final String address;
  final String blood;
  final int admin;

  MemberDetailScreenC({
    required this.id,
    required this.name,
    required this.number,
    required this.imageUrl,
    required this.address,
    required this.email,
    required this.blood,
    required this.admin,
  });

  @override
  State<MemberDetailScreenC> createState() => _MemberDetailScreenCState();
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

class _MemberDetailScreenCState extends State<MemberDetailScreenC> {
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
      drawer: CustomerDrawer(),
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
                            builder: (context) => MemberJennsyScreen(
                                  id: widget.admin,
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
                            builder: (context) => MemberDonationScreen(
                                  id: widget.admin,
                                )));
                  },
                  title: 'Cash',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
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
