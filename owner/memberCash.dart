import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CashDonationPage extends StatefulWidget {
  final int memberId;

  CashDonationPage({required this.memberId});

  @override
  _CashDonationPageState createState() => _CashDonationPageState();
}

class _CashDonationPageState extends State<CashDonationPage> {
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
        .where('donationType', isEqualTo: 'cash')
        .get();

    setState(() {
      _donations = querySnapshot.docs;
    });
  }

  double _calculateTotalSum(List<QueryDocumentSnapshot> donations) {
    double totalSum = 0;
    for (var donation in donations) {
      totalSum += donation['amount'] ?? 0;
    }
    return totalSum;
  }

  List<DataRow> _buildDonationRows(List<QueryDocumentSnapshot> donations) {
    List<DataRow> rows = [];
    int currentYear = 0;
    double yearlyTotal = 0;

    for (var donation in donations) {
      final amount = donation['amount'] ?? 0;
      final remarks = donation['remarks'] ?? "";
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
                      'Rs. ${yearlyTotal.toStringAsFixed(2)}',
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
                    Text('Rs. ${amount.toStringAsFixed(2)}'),
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
                      'Rs. ${yearlyTotal.toStringAsFixed(2)}',
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
        title: Text('Cash Donations'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Total Cash Donations: \$${_calculateTotalSum(_donations).toStringAsFixed(2)}',
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
