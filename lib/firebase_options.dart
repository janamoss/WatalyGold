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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBmkAwwEYIrdEyZ_FOkm3t4nDvIDvS1OK0',
    appId: '1:692047570487:web:206c3096e4156fb15281b2',
    messagingSenderId: '692047570487',
    projectId: 'watalygold',
    authDomain: 'watalygold.firebaseapp.com',
    storageBucket: 'watalygold.appspot.com',
    measurementId: 'G-8XEDQLLKFB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBG1W4W2v_-ZPbvrjgOLFJ-vXf3tjs6uog',
    appId: '1:692047570487:android:2cdcc7f2a5f3ac795281b2',
    messagingSenderId: '692047570487',
    projectId: 'watalygold',
    databaseURL: 'https://watalygold-default-rtdb.firebaseio.com',
    storageBucket: 'watalygold.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAU0CHOQeoatYg3W5IA_D8fviv9Hiicd0s',
    appId: '1:692047570487:ios:1158a9320f812ce25281b2',
    messagingSenderId: '692047570487',
    projectId: 'watalygold',
    databaseURL: 'https://watalygold-default-rtdb.firebaseio.com',
    storageBucket: 'watalygold.appspot.com',
    iosBundleId: 'com.example.watalygold',
  );

}