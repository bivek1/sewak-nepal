import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final firebaseMessaing = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    print("getitntntntntn");
    await firebaseMessaing.requestPermission();

    final FCMtoken = await firebaseMessaing.getToken();

    print("Token: $FCMtoken");
  }
}
