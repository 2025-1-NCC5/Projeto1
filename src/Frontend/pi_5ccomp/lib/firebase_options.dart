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
        return macos;
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
    apiKey: 'AIzaSyCyLB0HQEkF5T0OyJvrGuXnr7kLZRDQMqo',
    appId: '1:381017321474:web:4b40e3b11b2cff16c7f71b',
    messagingSenderId: '381017321474',
    projectId: 'ubarun-9a206',
    authDomain: 'ubarun-9a206.firebaseapp.com',
    storageBucket: 'ubarun-9a206.firebasestorage.app',
    measurementId: 'G-75HFWES8WD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCDYaBWXR4-S6nP8AqzBnl6GbT2lFoFHWw',
    appId: '1:381017321474:android:79f73465ee5dbaa8c7f71b',
    messagingSenderId: '381017321474',
    projectId: 'ubarun-9a206',
    storageBucket: 'ubarun-9a206.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAvyQpQ3an9861KNcgwr8Lg1tTIQgSKWyU',
    appId: '1:381017321474:ios:224f679290778393c7f71b',
    messagingSenderId: '381017321474',
    projectId: 'ubarun-9a206',
    storageBucket: 'ubarun-9a206.firebasestorage.app',
    iosClientId: '381017321474-j2a1iav90d04fpt06rql9e2943lhhv2l.apps.googleusercontent.com',
    iosBundleId: 'com.example.pi5ccomp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAvyQpQ3an9861KNcgwr8Lg1tTIQgSKWyU',
    appId: '1:381017321474:ios:224f679290778393c7f71b',
    messagingSenderId: '381017321474',
    projectId: 'ubarun-9a206',
    storageBucket: 'ubarun-9a206.firebasestorage.app',
    iosClientId: '381017321474-j2a1iav90d04fpt06rql9e2943lhhv2l.apps.googleusercontent.com',
    iosBundleId: 'com.example.pi5ccomp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCyLB0HQEkF5T0OyJvrGuXnr7kLZRDQMqo',
    appId: '1:381017321474:web:1d94a5843b6598aac7f71b',
    messagingSenderId: '381017321474',
    projectId: 'ubarun-9a206',
    authDomain: 'ubarun-9a206.firebaseapp.com',
    storageBucket: 'ubarun-9a206.firebasestorage.app',
    measurementId: 'G-J77T2VKHWX',
  );
}
