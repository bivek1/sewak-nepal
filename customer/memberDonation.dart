import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sewak/component/customerDrawer.dart';
import 'package:sewak/customer/store.dart';

class Donation {
  final int id;
  final double amount;
  final String donatedDate;
  final String remarks;
  final int member;

  Donation({
    required this.id,
    required this.amount,
    required this.donatedDate,
    required this.remarks,
    required this.member,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      id: json['id'],
      amount: json['amount'].toDouble(),
      donatedDate: json['donated_date'],
      remarks: json['remarks'],
      member: json['member'],
    );
  }
}

class MemberDonationScreen extends StatefulWidget {
  final int id;
  MemberDonationScreen({required this.id});
  @override
  _MemberDonationScreenState createState() => _MemberDonationScreenState();
}

class _MemberDonationScreenState extends State<MemberDonationScreen> {
  List<Donation> donations = [];
  Map<int, Map<int, double>> yearMonthTotals = {};
  double totalDonation = 0.0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  final List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  Future<void> fetchData() async {
    final apiUrl = 'https://sewak.watnepal.com/api-filter-donation/' +
        widget.id.toString();

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;

        setState(() {
          donations = jsonData.map((data) => Donation.fromJson(data)).toList();
          // Sort donations by the donated date (latest first)
          donations.sort((a, b) => b.donatedDate.compareTo(a.donatedDate));

          // Calculate year-month totals and total donation
          for (var donation in donations) {
            final dateParts = donation.donatedDate.split('-');
            final year = int.parse(dateParts[0]);
            final month = int.parse(dateParts[1]);
            final amount = donation.amount;

            yearMonthTotals[year] ??= {}; // Initialize year if null
            yearMonthTotals[year]![month] ??= 0; // Initialize month if null

            yearMonthTotals[year]?[month] =
                yearMonthTotals[year]![month]!.toInt() + amount;

            // Calculate total donation
            totalDonation += amount;
          }
        });
      } else {
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Network error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Donations',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      drawer: CustomerDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: donations.isEmpty
              ? Center(
                  child: Center(
                      child: Text("You haven't made any donation till now")))
              : Column(
                  children: [
                    // Display year-month totals
                    ...yearMonthTotals.keys.map((year) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            color: Colors
                                .blue, // Set your desired background color
                            padding:
                                EdgeInsets.all(10.0), // Add padding for spacing
                            child: Center(
                              child: Text(
                                'Year $year',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // Text color
                                ),
                              ),
                            ),
                          ),
                          // Text(
                          //   'Year RS.year',
                          //   style: TextStyle(
                          //     fontSize: 20.0,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          SizedBox(
                            height: 10,
                          ),
                          DataTable(
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => Color.fromARGB(255, 218, 43, 104)),
                            dataRowColor:
                                MaterialStateColor.resolveWith((states) {
                              return states.contains(MaterialState.selected)
                                  ? Color.fromARGB(255, 255, 76, 91)
                                  : Colors.white;
                            }),
                            columns: [
                              DataColumn(
                                label: Text('Month',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                              DataColumn(
                                label: Text('Total Amount',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                            ],
                            rows: yearMonthTotals[year]!.keys.map((month) {
                              final monthName = monthNames[month -
                                  1]; // Subtract 1 to get the correct index
                              return DataRow(
                                cells: [
                                  DataCell(Text(
                                    monthName,
                                    style: TextStyle(fontSize: 16.0),
                                  )),
                                  DataCell(Text(
                                    'RS.${yearMonthTotals[year]![month]!.toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: 16.0),
                                  )),
                                ],
                              );
                            }).toList(),
                          ),
                          // Display total amount for the year
                          Text(
                            'Total Amount for Year $year: Rs. ${yearMonthTotals[year]!.values.reduce((a, b) => a + b).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    }),
                    Divider(),
                    SizedBox(
                      height: 30,
                    ),
                    // Display total sum of all donations
                    Container(
                      color: Colors.blue, // Set your desired background color
                      padding: EdgeInsets.all(10.0), // Add padding for spacing
                      child: Center(
                        child: Text(
                          'Total Sum of All Donations: Rs. ${totalDonation.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Text color
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    DataTable(
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Color.fromARGB(255, 218, 43, 104)),
                      dataRowColor: MaterialStateColor.resolveWith((states) {
                        return states.contains(MaterialState.selected)
                            ? Color.fromARGB(255, 255, 76, 91)
                            : Colors.white;
                      }),
                      columns: [
                        DataColumn(
                          label: Text('Amount',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                        DataColumn(
                          label: Text('Date',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                        DataColumn(
                          label: Text('Remarks',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ],
                      rows: donations.map((donation) {
                        final dateParts = donation.donatedDate.split('-');
                        final year = int.parse(dateParts[0]);
                        final month = int.parse(dateParts[1]);
                        final monthName = monthNames[
                            month - 1]; // Subtract 1 to get the correct index
                        return DataRow(
                          cells: [
                            DataCell(Text(
                              'Rs. ${donation.amount.toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 16.0),
                            )),
                            DataCell(Text(
                              '$monthName ${dateParts[2]}, $year',
                              style: TextStyle(fontSize: 16.0),
                            )),
                            DataCell(Text(
                              donation.remarks,
                              style: TextStyle(fontSize: 16.0),
                            )),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
