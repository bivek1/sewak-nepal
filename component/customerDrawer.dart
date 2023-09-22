import 'package:flutter/material.dart';

class CustomerDrawer extends StatefulWidget {
  const CustomerDrawer({super.key});

  @override
  State<CustomerDrawer> createState() => _CustomerDrawerState();
}

class _CustomerDrawerState extends State<CustomerDrawer> {
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
              Navigator.pushNamed(context, 'customer');
            },
          ),
          ListTile(
            leading: Icon(Icons.supervised_user_circle_rounded),
            title: Text('Member'),
            onTap: () {
              // TODO: Handle navigation to settings
              Navigator.pushNamed(context, 'customer_member');
            },
          ),

          ListTile(
            leading: Icon(Icons.newspaper),
            title: Text('News'),
            onTap: () {
              // TODO: Handle navigation to settings
              Navigator.pushNamed(context, 'customer_news');
            },
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text('Events'),
            onTap: () {
              // TODO: Handle navigation to settings
              Navigator.pushNamed(context, 'customer_event');
            },
          ),

          // ListTile(
          //   leading: Icon(Icons.money),
          //   title: Text('Donation List'),
          //   onTap: () {
          //     // TODO: Handle navigation to settings
          //     Navigator.pushNamed(context, 'donation');
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.food_bank),
          //   title: Text('Jensy Donation'),
          //   onTap: () {
          //     // TODO: Handle navigation to settings
          //     Navigator.pushNamed(context, 'jensy');
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.support),
            title: Text('Volunteer Form'),
            onTap: () {
              // TODO: Handle navigation to settings
              Navigator.pushNamed(context, 'customer_volunteer');
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Bank Details'),
            onTap: () {
              // TODO: Handle navigation to settings
              Navigator.pushNamed(context, 'customer_bank');
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
              Navigator.pushNamed(context, 'customer_karyasamiti');
            },
          ),
          ListTile(
            leading: Icon(Icons.child_friendly),
            title: Text('Balbalika'),
            onTap: () {
              // TODO: Handle navigation to settings
              Navigator.pushNamed(context, 'customer_children');
            },
          ),
          ListTile(
            leading: Icon(Icons.workspace_premium_sharp),
            title: Text('Karmachari'),
            onTap: () {
              // TODO: Handle navigation to settings
              Navigator.pushNamed(context, 'customer_staff');
            },
          ),

          ListTile(
            leading: Icon(Icons.facebook_rounded),
            title: Text('Connect with us'),
            onTap: () {
              // TODO: Handle navigation to settings
              Navigator.pushNamed(context, 'customer_social');
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
