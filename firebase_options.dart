// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBnCtzUDsf71YgoHke0uEaAk7U44k74Ivo',
    appId: '1:20576966270:web:c4702e9adb178ad6206a2f',
    messagingSenderId: '20576966270',
    projectId: 'sewak-34755',
    authDomain: 'sewak-34755.firebaseapp.com',
    storageBucket: 'sewak-34755.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDsxvuMo_YDqSzaWDQp1Ml7yvr_vfbgwIE',
    appId: '1:20576966270:android:e6f4b9d591b26355206a2f',
    messagingSenderId: '20576966270',
    projectId: 'sewak-34755',
    storageBucket: 'sewak-34755.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA7Dtmxn5FPOaBybH-0DL6sGZJGRtFKrDg',
    appId: '1:20576966270:ios:d38e93df49700171206a2f',
    messagingSenderId: '20576966270',
    projectId: 'sewak-34755',
    storageBucket: 'sewak-34755.appspot.com',
    iosBundleId: 'com.example.sewak',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA7Dtmxn5FPOaBybH-0DL6sGZJGRtFKrDg',
    appId: '1:20576966270:ios:186aa94eb5991323206a2f',
    messagingSenderId: '20576966270',
    projectId: 'sewak-34755',
    storageBucket: 'sewak-34755.appspot.com',
    iosBundleId: 'com.example.sewak.RunnerTests',
  );
}
