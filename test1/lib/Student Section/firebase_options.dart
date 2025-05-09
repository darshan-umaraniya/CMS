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
    apiKey: 'AIzaSyAff5w0BL5XOYa-uypuEKA_OE_5zq_TgHo',
    appId: '1:568955745237:web:64e8aa03b2bdc2196f435c',
    messagingSenderId: '568955745237',
    projectId: 'curious-striker-411003',
    authDomain: 'curious-striker-411003.firebaseapp.com',
    databaseURL: 'https://curious-striker-411003-default-rtdb.firebaseio.com',
    storageBucket: 'curious-striker-411003.firebasestorage.app',
    measurementId: 'G-MCPRHTFFPE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxR7k8rNpRQOgj8sNqiH-kjzfZuxcgX5U',
    appId: '1:568955745237:android:8247d03052d7f9de6f435c',
    messagingSenderId: '568955745237',
    projectId: 'curious-striker-411003',
    databaseURL: 'https://curious-striker-411003-default-rtdb.firebaseio.com',
    storageBucket: 'curious-striker-411003.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBsNJFVcyXEtl2QyplWXXHISeQX_cD4-uo',
    appId: '1:568955745237:ios:c3c338727ec2778f6f435c',
    messagingSenderId: '568955745237',
    projectId: 'curious-striker-411003',
    databaseURL: 'https://curious-striker-411003-default-rtdb.firebaseio.com',
    storageBucket: 'curious-striker-411003.firebasestorage.app',
    iosBundleId: 'com.example.flutterDemo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBsNJFVcyXEtl2QyplWXXHISeQX_cD4-uo',
    appId: '1:568955745237:ios:c3c338727ec2778f6f435c',
    messagingSenderId: '568955745237',
    projectId: 'curious-striker-411003',
    databaseURL: 'https://curious-striker-411003-default-rtdb.firebaseio.com',
    storageBucket: 'curious-striker-411003.firebasestorage.app',
    iosBundleId: 'com.example.flutterDemo',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAff5w0BL5XOYa-uypuEKA_OE_5zq_TgHo',
    appId: '1:568955745237:web:f2347345ee3ba0f76f435c',
    messagingSenderId: '568955745237',
    projectId: 'curious-striker-411003',
    authDomain: 'curious-striker-411003.firebaseapp.com',
    databaseURL: 'https://curious-striker-411003-default-rtdb.firebaseio.com',
    storageBucket: 'curious-striker-411003.firebasestorage.app',
    measurementId: 'G-J36F5MBQ73',
  );
}
