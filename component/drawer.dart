import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Center(
            child: Text(
              "Sewak Nepal Menu",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              // TODO: Handle navigation to home
              Navigator.pushNamed(context, 'dashboard');
            },
          ),
          ListTile(
            leading: Icon(Icons.supervised_user_circle_rounded),
            title: Text('Member'),
            onTap: () {
              // TODO: Handle navigation to settings
              Navigator.pushNamed(context, 'member');
            },
          ),
          ListTile(
            leading: Icon(Icons.account_balance),
            title: Text('Account Information'),
            onTap: () {
              // TODO: Handle navigation to settings
              Navigator.pushNamed(context, 'account');
            },
          ),
          ListTile(
            leading: Icon(Icons.newspaper),
            title: Text('News'),
            onTap: () {
              // TODO: Handle navigation to settings
              Navigator.pushNamed(context, 'news');
            },
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text('Events'),
            onTap: () {
              // TODO: Handle navigation to settings
              Navigator.pushNamed(context, 'event');
            },
          ),
          ListTile(
            leading: Icon(Icons.notification_add_rounded),
            title: Text('Push Notification'),
            onTap: () {
              // TODO: Handle navigation to settings
              Navigator.pushNamed(context, 'notification');
            },
          ),
          ListTile(
            leading: Icon(Icons.money),
            title: Text('Donation List'),
            onTap: () {
              // TODO: Handle navigation to settings
              Navigator.pushNamed(context, 'donation');
            },
          ),
          ListTile(
            leading: Icon(Icons.food_bank),
            title: Text('Jensy Donation'),
            onTap: () {
              // TODO: Handle navigation to settings
              Navigator.pushNamed(context, 'jensy');
            },
          ),
          ListTile(
            leading: Icon(Icons.support),
            title: Text('Volunteer Form'),
            onTap: () {
              // TODO: Handle navigation to settings
              Navigator.pushNamed(context, 'volunteer');
            },
          ),
          ListTile(
            leading: Icon(Icons.admin_panel_settings),
            title: Text('Admins'),
            onTap: () {
              // TODO: Handle navigation to settings
              Navigator.pushNamed(context, 'admin');
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_album),
            title: Text('Photos'),
            onTap: () {
              // TODO: Handle navigation to settings
              Navigator.pushNamed(context, 'gallary');
            },
          ),
          ListTile(
            leading: Icon(Icons.movie),
            title: Text('Video'),
            onTap: () {
              // TODO: Handle navigation to settings
              Navigator.pushNamed(context, 'gallary');
            },
          ),
          ListTile(
            leading: Icon(Icons.emoji_people_outlined),
            title: Text('Karya Samiti'),
            onTap: () {
              // TODO: Handle navigation to settings
              Navigator.pushNamed(context, 'karyasamiti');
            },
          ),
          ListTile(
            leading: Icon(Icons.child_friendly),
            title: Text('Balbalika'),
            onTap: () {
              // TODO: Handle navigation to settings
              Navigator.pushNamed(context, 'children');
            },
          ),
          ListTile(
            leading: Icon(Icons.workspace_premium_sharp),
            title: Text('Karmachari'),
            onTap: () {
              // TODO: Handle navigation to settings
              Navigator.pushNamed(context, 'staff');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              // TODO: Handle navigation to settings
              Navigator.pushNamed(context, 'home');
            },
          ),
        ],
      ),
    );
  }
}
