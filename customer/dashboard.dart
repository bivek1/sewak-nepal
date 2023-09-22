import 'package:flutter/material.dart';
import 'package:sewak/component/customerDrawer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({super.key});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<ChartData> monthlyDonations = [
    ChartData('Jan', 100.0),
    ChartData('Feb', 150.0),
    ChartData('Mar', 200.0),
    ChartData('Apr', 250.0),
    ChartData('May', 300.0),
    ChartData('Jun', 350.0),
    ChartData('Jul', 400.0),
    ChartData('Aug', 450.0),
    ChartData('Sep', 500.0),
    ChartData('Oct', 550.0),
    ChartData('Nov', 600.0),
    ChartData('Dec', 650.0),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sewak Nepal'),
        ),
        drawer: CustomerDrawer(),
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome Back!!",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Divider(),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DashboardBox(
                    icon: Image(image: AssetImage('images/donate-sm.jpeg')),
                    onPressed: () {
                      Navigator.pushNamed(context, 'donation');
                    },
                    title: '300 Donation'),
                DashboardBox(
                    icon: Image(image: AssetImage('images/jensy-sm.png')),
                    onPressed: () {
                      Navigator.pushNamed(context, 'jenssy');
                    },
                    title: '10 Jennsy'),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "तपाईंको अन्तिम दान भएको 23 दिन भयो",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: MediaQuery.of(context).size.width * .9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white, // White background color
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.grey.withOpacity(0.5), // Shadow color
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: Offset(0, 4), // Offset of the shadow
                            ),
                          ],
                        ),
                        height: 50,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.money_rounded),
                                iconSize: 34,
                                color: Colors.blueAccent,
                                onPressed: () {},
                              ),
                              Text(
                                "Rs. 5600 donated till now      ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Your Donation Bar",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      ElevatedButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.done_all),
                              Text("See All"),
                            ],
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MonthlyDonationBarGraph(data: monthlyDonations),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(),
                  Center(
                    child: Text(
                      "Scan QR Code",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Divider(),
                  Image(image: AssetImage('images/qr.jpeg')),

                  // SizedBox(
                  //   height: 20,
                  // ),
                  // Expanded(
                  //   child: MonthlyDonationBarGraph(data: monthlyDonations),
                  // ),
                ],
              ),
            ),
          ]),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_rounded),
              label: 'Members',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueAccent,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class DashboardBox extends StatelessWidget {
  final Image icon;
  final String title;
  final VoidCallback onPressed;

  const DashboardBox(
      {required this.icon, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white, // White background color
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Shadow color
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(0, 4), // Offset of the shadow
              ),
            ],
          ),
          height: 100,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: icon,
                  iconSize: 34,
                  color: Colors.blueAccent,
                  onPressed: () {},
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MonthlyDonationBarGraph extends StatelessWidget {
  final List<ChartData> data; // List of monthly donation data points

  MonthlyDonationBarGraph({required this.data});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Amount'),
      ),
      series: <ChartSeries>[
        BarSeries<ChartData, String>(
          dataSource: data,
          xValueMapper: (ChartData sales, _) => sales.month,
          yValueMapper: (ChartData sales, _) => sales.amount,
          dataLabelSettings: DataLabelSettings(isVisible: true),
          color: Colors.blue, // Change the bar color to blue
        ),
      ],
    );
  }
}

class ChartData {
  final String month;
  final double amount;

  ChartData(this.month, this.amount);
}
