import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sewak/customer/store.dart';

class Jennsy {
  final int id;
  final String donated;
  final String donatedDate;
  final String remarks;
  final int member;

  Jennsy({
    required this.id,
    required this.donated,
    required this.donatedDate,
    required this.remarks,
    required this.member,
  });

  factory Jennsy.fromJson(Map<String, dynamic> json) {
    return Jennsy(
      id: json['id'],
      donated: json['donated'],
      donatedDate: json['donated_date'],
      remarks: json['remarks'],
      member: json['member'],
    );
  }
}

class MemberJennsyScreen extends StatefulWidget {
  final int id;

  MemberJennsyScreen({required this.id});
  @override
  _MemberJennsyScreenState createState() => _MemberJennsyScreenState();
}

class _MemberJennsyScreenState extends State<MemberJennsyScreen> {
  List<Jennsy> jennsys = [];

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  Future<void> fetchData() async {
    final apiUrl =
        'https://sewak.watnepal.com/api-filter-jennsy/' + widget.id.toString();

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;

        setState(() {
          jennsys = jsonData.map((data) => Jennsy.fromJson(data)).toList();
          // Sort jennsys by the donated date (latest first)
          jennsys.sort((a, b) => b.donatedDate.compareTo(a.donatedDate));
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
          'Jennsy',
          style: TextStyle(
            fontSize: 24.0, // Increase the font size
            fontWeight: FontWeight.bold, // Make it bold
          ),
        ),
        backgroundColor: Colors.blue, // Change the app bar color
        elevation: 0, // Remove shadow
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: jennsys.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) =>
                      Color.fromARGB(255, 218, 43, 104)), // Header row color
                  dataRowColor: MaterialStateColor.resolveWith((states) {
                    // Alternating row colors
                    return states.contains(MaterialState.selected)
                        ? Color.fromARGB(255, 255, 76, 91)
                        : Colors.white;
                  }),
                  columns: [
                    DataColumn(
                      label: Text('Items',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)), // Header text style
                    ),
                    DataColumn(
                      label: Text('Date',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)), // Header text style
                    ),
                    DataColumn(
                      label: Text('Remarks',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)), // Header text style
                    ),
                  ],
                  rows: jennsys.map((jennsy) {
                    return DataRow(
                      cells: [
                        DataCell(Text(
                          '${jennsy.donated}',
                          style: TextStyle(fontSize: 16.0),
                        )),
                        DataCell(Text(
                          jennsy.donatedDate,
                          style: TextStyle(fontSize: 16.0),
                        )),
                        DataCell(Text(
                          jennsy.remarks,
                          style: TextStyle(fontSize: 16.0),
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
      ),
    );
  }
}
