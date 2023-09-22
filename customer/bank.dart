import 'package:flutter/material.dart';
import 'package:sewak/component/customerDrawer.dart';

class CustomerBank extends StatefulWidget {
  const CustomerBank({super.key});

  @override
  State<CustomerBank> createState() => _CustomerBankState();
}

class _CustomerBankState extends State<CustomerBank> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text('Donate us'), backgroundColor: Colors.blueAccent),
        drawer: CustomerDrawer(),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image(image: AssetImage('images/logo.png')),
                        Column(
                          children: [
                            Text(
                              "Sewak Nepal",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            Text(
                              "सेवक नेपाल",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.redAccent),
                            )
                          ],
                        )
                      ],
                    ),
                    Divider(),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "हाम्रो बैंक खाता विवरण",
                      style: TextStyle(fontSize: 23),
                    ),
                    Divider(),
                    Image(image: AssetImage('images/bankd.jpeg')),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(),
                    Text(
                      "Scan QR Code",
                      style: TextStyle(fontSize: 23),
                    ),
                    Divider(),
                    Image(image: AssetImage('images/qr.jpeg')),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
