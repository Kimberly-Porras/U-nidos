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
    apiKey: 'AIzaSyBgegeuDrykyxFLyJFxrKjpopUgnN1194Q',
    appId: '1:591644049352:web:188adbfc5abe7b31ec0afd',
    messagingSenderId: '591644049352',
    projectId: 'u-nidos-14954',
    authDomain: 'u-nidos-14954.firebaseapp.com',
    storageBucket: 'u-nidos-14954.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAOipz3QD8Ltf_qFAVuhlA5UVzYqpCMQ7w',
    appId: '1:591644049352:android:a3a980cd5af0ec4aec0afd',
    messagingSenderId: '591644049352',
    projectId: 'u-nidos-14954',
    storageBucket: 'u-nidos-14954.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCxI-nvowH9qxxtA31gcK6fUgRUsaFsmck',
    appId: '1:591644049352:ios:2c7fc9a216aa7ceeec0afd',
    messagingSenderId: '591644049352',
    projectId: 'u-nidos-14954',
    storageBucket: 'u-nidos-14954.firebasestorage.app',
    iosBundleId: 'com.example.uNidos',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCxI-nvowH9qxxtA31gcK6fUgRUsaFsmck',
    appId: '1:591644049352:ios:2c7fc9a216aa7ceeec0afd',
    messagingSenderId: '591644049352',
    projectId: 'u-nidos-14954',
    storageBucket: 'u-nidos-14954.firebasestorage.app',
    iosBundleId: 'com.example.uNidos',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBgegeuDrykyxFLyJFxrKjpopUgnN1194Q',
    appId: '1:591644049352:web:e3c8788ed9b81f6bec0afd',
    messagingSenderId: '591644049352',
    projectId: 'u-nidos-14954',
    authDomain: 'u-nidos-14954.firebaseapp.com',
    storageBucket: 'u-nidos-14954.firebasestorage.app',
  );
}
