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
    apiKey: 'AIzaSyB8kyNkqjmxfWvytmy7NQ8UQr9Tb9XWZ0g',
    appId: '1:945155118272:web:9bf31926c0df447f524925',
    messagingSenderId: '945155118272',
    projectId: 'shopping-list-11411',
    authDomain: 'shopping-list-11411.firebaseapp.com',
    databaseURL: 'https://shopping-list-11411-default-rtdb.firebaseio.com',
    storageBucket: 'shopping-list-11411.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAwrNC1D9jjPLEvYVDdqYMVZnOWgiX1RH8',
    appId: '1:945155118272:android:11f62a6049ff7371524925',
    messagingSenderId: '945155118272',
    projectId: 'shopping-list-11411',
    databaseURL: 'https://shopping-list-11411-default-rtdb.firebaseio.com',
    storageBucket: 'shopping-list-11411.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBT__qVeXUHIA-StpSAUPYlxKHy19PW4tQ',
    appId: '1:945155118272:ios:190474c10ae5a06e524925',
    messagingSenderId: '945155118272',
    projectId: 'shopping-list-11411',
    databaseURL: 'https://shopping-list-11411-default-rtdb.firebaseio.com',
    storageBucket: 'shopping-list-11411.appspot.com',
    iosClientId: '945155118272-n0i0nl3gratk66ioou50cmnn46d51fuu.apps.googleusercontent.com',
    iosBundleId: 'com.example.shoppingList',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBT__qVeXUHIA-StpSAUPYlxKHy19PW4tQ',
    appId: '1:945155118272:ios:39917ff6deb67a20524925',
    messagingSenderId: '945155118272',
    projectId: 'shopping-list-11411',
    databaseURL: 'https://shopping-list-11411-default-rtdb.firebaseio.com',
    storageBucket: 'shopping-list-11411.appspot.com',
    iosClientId: '945155118272-bl3lu8e6cjkf0nnlsv1bhu43nfifmp45.apps.googleusercontent.com',
    iosBundleId: 'com.example.shoppingList.RunnerTests',
  );
}
