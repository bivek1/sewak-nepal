import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sewak/customer/bank.dart';
import 'package:sewak/customer/children.dart';
import 'package:sewak/customer/dashboard.dart';
import 'package:sewak/customer/donation.dart';
import 'package:sewak/customer/event.dart';
import 'package:sewak/customer/jennsy.dart';
import 'package:sewak/customer/karyasamiti.dart';
import 'package:sewak/customer/member.dart';
import 'package:sewak/customer/news.dart';
import 'package:sewak/customer/picture.dart';
import 'package:sewak/customer/social.dart';
import 'package:sewak/customer/staff.dart';
import 'package:sewak/customer/video.dart';
import 'package:sewak/customer/volunter.dart';
import 'package:sewak/firebase_api.dart';
import 'package:sewak/firebase_options.dart';
import 'package:sewak/owner/account.dart';
import 'package:sewak/owner/admin.dart';
import 'package:sewak/owner/children.dart';
import 'package:sewak/owner/crud/addAdmin.dart';
import 'package:sewak/owner/crud/addDonation.dart';
import 'package:sewak/owner/crud/addEvent.dart';
import 'package:sewak/owner/crud/addJensy.dart';
import 'package:sewak/owner/crud/addMember.dart';
import 'package:sewak/owner/crud/addNews.dart';
import 'package:sewak/owner/crud/addVolunter.dart';
import 'package:sewak/owner/crud/updateDonation.dart';
import 'package:sewak/owner/crud/updateJensy.dart';
import 'package:sewak/owner/crud/updateMember.dart';
import 'package:sewak/owner/crud/updateNews.dart';
import 'package:sewak/owner/crud/updateVolunter.dart';
import 'package:sewak/owner/donation.dart';
import 'package:sewak/owner/event.dart';
import 'package:sewak/owner/gallary.dart';
import 'package:sewak/owner/jensy.dart';
import 'package:sewak/owner/karyasamiti.dart';
import 'package:sewak/owner/member.dart';
import 'package:sewak/owner/news.dart';
import 'package:sewak/owner/notification.dart';
import 'package:sewak/owner/search.dart';
import 'package:sewak/owner/setting.dart';
import 'package:sewak/owner/staff.dart';
import 'package:sewak/owner/volunter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'customer/signup.dart';
import 'owner/dashboard.dart';
import 'customer/number.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();

  // runApp(MyApp(prefs: prefs));
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserIdProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'home',
        routes: {
          'home': (context) => LoginScreen(),
          'register': (context) => Register(),
          'number': (context) => MyNumber(),

          // Owner Routes
          'dashboard': (context) => Dashboard(),
          'account': (context) => MyAccount(),
          'donation': (context) => MyDonation(),
          'jensy': (context) => MyJensy(),
          'member': (context) => MyMember(),
          'news': (context) => MyNews(),
          'event': (context) => MyEvent(),
          'notification': (context) => MyNotification(),
          'search': (context) => MySearch(),
          'settting': (context) => MySetting(),
          'volunteer': (context) => MyVolunteer(),
          'admin': (context) => MyAdmin(),
          'karyasamiti': (context) => MyKaryasamiti(),
          'children': (context) => MyChildren(),
          'staff': (context) => MyStaff(),

          // Crud Operation
          'addMember': (context) => AddMember(),
          'addDonation': (context) => AddDonation(),
          'addJensy': (context) => AddJensy(),
          'addNews': (context) => AddNews(),
          'addEvent': (context) => AddEvent(),
          'addVolunter': (context) => AddVolunteer(),
          'updateMember': (context) => UpdateMember(),
          'addAdmin': (context) => AddAdmin(),
          'gallary': (context) => MyGallary(),

          // Customer Dashbaord Pages,
          'customer': (context) => CustomerDashboard(),
          'customer_member': (context) => CustomerMember(),
          'customer_news': (context) => CustomerNews(),
          'customer_event': (context) => CustomerEvent(),
          'customer_volunteer': (context) => CustomerVolunteer(),
          'customer_karyasamiti': (context) => CustomerKaryasamiti(),
          'customer_staff': (context) => CustomerStaff(),
          'customer_bank': (context) => CustomerBank(),
          'customer_social': (context) => CustomerSocial(),
          'customer_children': (context) => CustomerChildren(),
          'customer_donation': (context) => DonationScreen(),
          'customer_jennsy': (context) => JennsyScreen(),
          'customer_photo': (context) => Picture(),
          'customer_video': (context) => VideoPage(),

          // Owner Routes
          'dashboard': (context) => Dashboard(),
        },
      ),
    ),
  );
}

class UserIdProvider with ChangeNotifier {
  int? _userId;

  int? get userId => _userId;

  void setUserId(int id) {
    _userId = id;
    notifyListeners();
  }
}
