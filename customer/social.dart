import 'package:flutter/material.dart';
import 'package:sewak/component/customerDrawer.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerSocial extends StatefulWidget {
  const CustomerSocial({super.key});

  @override
  State<CustomerSocial> createState() => _CustomerSocialState();
}

class _CustomerSocialState extends State<CustomerSocial> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text('Connect with us'), backgroundColor: Colors.blueAccent),
        drawer: CustomerDrawer(),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                children: [
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
                    height: 10,
                  ),
                  Text(
                    "Connect with us",
                    style: TextStyle(fontSize: 23),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.facebook_rounded,
                        size: 40,
                        color: Colors.blueAccent,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle the tap event here, e.g., open a web URL
                          _launchURL(
                              'https://www.facebook.com/jasmine.rai.37?mibextid=MKOS29');
                        },
                        child: Text(
                          'Click here to visit our facebook',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors
                                .blue, // Set the text color to blue for a link-like appearance
                            decoration: TextDecoration
                                .underline, // Add an underline to the text
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.web_rounded,
                        size: 40,
                        color: Colors.blueAccent,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle the tap event here, e.g., open a web URL
                          _launchURL('https://sewaknepal.org');
                        },
                        child: Text(
                          'Click here to visit our website',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors
                                .blue, // Set the text color to blue for a link-like appearance
                            decoration: TextDecoration
                                .underline, // Add an underline to the text
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
