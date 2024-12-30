// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyA2Y-1EZYYbgeWucK-SLiK7mSQVVDxmZAc',
    appId: '1:560555940513:web:85cd7a3c665106a6896ee0',
    messagingSenderId: '560555940513',
    projectId: 'supplyappg',
    authDomain: 'supplyappg.firebaseapp.com',
    storageBucket: 'supplyappg.firebasestorage.app',
    measurementId: 'G-MFK4BW829C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCK7WOD9zh-bxxSoI8NTaKceMqvHofSQBk',
    appId: '1:560555940513:android:44dce91222f60ed9896ee0',
    messagingSenderId: '560555940513',
    projectId: 'supplyappg',
    storageBucket: 'supplyappg.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCAu0AkgPbejUDcjlR6amE40NfuaFMDlhg',
    appId: '1:560555940513:ios:d625d5b1f1e4d444896ee0',
    messagingSenderId: '560555940513',
    projectId: 'supplyappg',
    storageBucket: 'supplyappg.firebasestorage.app',
    iosBundleId: 'com.example.supplyApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA2Y-1EZYYbgeWucK-SLiK7mSQVVDxmZAc',
    appId: '1:560555940513:web:e41584ddf54cc61c896ee0',
    messagingSenderId: '560555940513',
    projectId: 'supplyappg',
    authDomain: 'supplyappg.firebaseapp.com',
    storageBucket: 'supplyappg.firebasestorage.app',
    measurementId: 'G-498CC0Q0G8',
  );
}
