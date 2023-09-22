import 'package:flutter/material.dart';

class TabViewPage extends StatefulWidget {
  @override
  _TabViewPageState createState() => _TabViewPageState();
}

class _TabViewPageState extends State<TabViewPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tab View'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Tab 1'),
              Tab(text: 'Tab 2'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Tab1List(),
            Tab2List(),
          ],
        ),
      ),
    );
  }
}

class Tab1List extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Example: List size for Tab 1
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Item ${index + 1} - Tab 1'),
        );
      },
    );
  }
}

class Tab2List extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8, // Example: List size for Tab 2
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Item ${index + 1} - Tab 2'),
        );
      },
    );
  }
}