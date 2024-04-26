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
    apiKey: 'AIzaSyAv9DSFxDZjkBVeP2Rh_6f1sAJKC4-mdqw',
    appId: '1:382862372221:web:cb88aebcb804210660b014',
    messagingSenderId: '382862372221',
    projectId: 'cache-images',
    authDomain: 'cache-images.firebaseapp.com',
    databaseURL: 'https://cache-images-default-rtdb.firebaseio.com',
    storageBucket: 'cache-images.appspot.com',
    measurementId: 'G-JWL539F0S4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC8p93sc7OURKL3xJws1v-OpUe-vGn9Re8',
    appId: '1:382862372221:android:9d8253a25f7e365b60b014',
    messagingSenderId: '382862372221',
    projectId: 'cache-images',
    databaseURL: 'https://cache-images-default-rtdb.firebaseio.com',
    storageBucket: 'cache-images.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCruDuKlJGx34awowiHB7DfcVV986945g0',
    appId: '1:382862372221:ios:4a0568036f7d1f6260b014',
    messagingSenderId: '382862372221',
    projectId: 'cache-images',
    databaseURL: 'https://cache-images-default-rtdb.firebaseio.com',
    storageBucket: 'cache-images.appspot.com',
    iosBundleId: 'com.example.cacheImage',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCruDuKlJGx34awowiHB7DfcVV986945g0',
    appId: '1:382862372221:ios:9021939644c4f2cb60b014',
    messagingSenderId: '382862372221',
    projectId: 'cache-images',
    databaseURL: 'https://cache-images-default-rtdb.firebaseio.com',
    storageBucket: 'cache-images.appspot.com',
    iosBundleId: 'com.example.cacheImage.RunnerTests',
  );
}
