import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Platform-specific configuration
    // This is just an example; you need to fill in the actual values.
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBQtJj22JIu7VRcOohTHfDXx5V0xzKmmvY',
    appId: '1:285574404343:android:aea4f419424bc72bd59bf2',
    messagingSenderId: '285574404343',
    projectId: 'mirchily-9f842',
    storageBucket: 'mirchily-9f842.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBQtJj22JIu7VRcOohTHfDXx5V0xzKmmvY',
    appId: '1:285574404343:android:aea4f419424bc72bd59bf2',
    messagingSenderId: '285574404343',
    projectId: 'mirchily-9f842',
  );

}