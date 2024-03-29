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
    apiKey: 'AIzaSyCfrJFA-FbPl1iNtEONYgo4eKIAaJ3chgg',
    appId: '1:647634644258:web:a05163113830aeeff0097b',
    messagingSenderId: '647634644258',
    projectId: 'michelie',
    authDomain: 'michelie.firebaseapp.com',
    databaseURL: 'https://michelie-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'michelie.appspot.com',
    measurementId: 'G-LPJ0JP3SRP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDcRGTRSCz2v4SVFN9SJd-_BOo-1asmI6s',
    appId: '1:647634644258:android:bf3387f97c651249f0097b',
    messagingSenderId: '647634644258',
    projectId: 'michelie',
    databaseURL: 'https://michelie-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'michelie.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDMy7XhB1ePg3lSVnRYmKkrzs5vylZx3n4',
    appId: '1:647634644258:ios:ab8defb348e686c0f0097b',
    messagingSenderId: '647634644258',
    projectId: 'michelie',
    databaseURL: 'https://michelie-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'michelie.appspot.com',
    iosBundleId: 'com.example.michelie2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDMy7XhB1ePg3lSVnRYmKkrzs5vylZx3n4',
    appId: '1:647634644258:ios:92968045c24873b1f0097b',
    messagingSenderId: '647634644258',
    projectId: 'michelie',
    databaseURL: 'https://michelie-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'michelie.appspot.com',
    iosBundleId: 'com.example.michelie2.RunnerTests',
  );
}
