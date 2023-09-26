import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class JennsyDonationPage extends StatefulWidget {
  final int memberId;

  JennsyDonationPage({required this.memberId});

  @override
  _JennsyDonationPageState createState() => _JennsyDonationPageState();
}

class _JennsyDonationPageState extends State<JennsyDonationPage> {
  List<QueryDocumentSnapshot> _donations = [];

  @override
  void initState() {
    super.initState();
    _loadDonations();
  }

  Future<void> _loadDonations() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('memberDonation')
        .where('memberId', isEqualTo: widget.memberId)
        .where('donationType', isEqualTo: 'jennsy')
        .get();

    setState(() {
      _donations = querySnapshot.docs;
    });
  }

  int totalSum = 0;
  int _calculateTotalSum(List<QueryDocumentSnapshot> donations) {
    for (var donation in donations) {
      totalSum += 1;
    }
    setState(() {
      totalSum = totalSum;
    });
    return totalSum;
  }

  List<DataRow> _buildDonationRows(List<QueryDocumentSnapshot> donations) {
    List<DataRow> rows = [];
    int currentYear = 0;
    double yearlyTotal = 0;

    for (var donation in donations) {
      final amount = donation['amount'] ?? 0;
      final remarks = donation['remarks'] ?? "";
      final jennsy = donation['jennsy'] ?? "";
      final date = donation['date'] != null
          ? (donation['date'] as Timestamp).toDate()
          : DateTime.now();

      // Check if a new year has started
      if (date.year != currentYear) {
        // Add a row with the yearly total
        if (currentYear != 0) {
          rows.add(
            DataRow(
              cells: [
                DataCell(
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Total for $currentYear:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green, // Highlight in green
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Total Donation: ${totalSum}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green, // Highlight in green
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Update the current year and reset yearly total
        currentYear = date.year;
        yearlyTotal = 0;
      }

      yearlyTotal += amount;

      String formattedDate = DateFormat('yyyy-MM-dd').format(date.toLocal());
      rows.add(
        DataRow(
          cells: [
            DataCell(
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(formattedDate),
                    Text('Remarks: ${remarks}'),
                  ],
                ),
              ),
            ),
            DataCell(
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('${jennsy}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Add the final year's total
    if (currentYear != 0) {
      rows.add(
        DataRow(
          cells: [
            DataCell(
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Total for $currentYear:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green, // Highlight in green
                      ),
                    ),
                  ],
                ),
              ),
            ),
            DataCell(
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${yearlyTotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green, // Highlight in green
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jennsy Donations'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Total Jennsy Donations: ${_calculateTotalSum(_donations).toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: DataTable(
                headingRowColor: MaterialStateColor.resolveWith(
                    (states) => Colors.blue), // Color for the header row
                dataRowColor: MaterialStateColor.resolveWith(
                    (states) => Colors.grey[200]!), // Color for data rows
                columns: [
                  DataColumn(
                    label: Center(
                        child: Text('Date',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                  DataColumn(
                    label: Center(
                        child: Text('Amount',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                  // DataColumn(
                  //   label: Center(
                  //       child: Column(
                  //     children: [
                  //       Text('Amount',
                  //           style: TextStyle(fontWeight: FontWeight.bold)),
                  //     ],
                  //   )),
                  // ),
                ],
                rows: _buildDonationRows(_donations),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
