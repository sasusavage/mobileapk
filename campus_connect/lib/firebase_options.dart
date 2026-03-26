import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBtPhAmjOiAEJ5pCqIQblL1e5x9bRP0blU',
    appId: '1:38104863071:web:e16ad604d5c8a7bd3c26ea',
    messagingSenderId: '38104863071',
    projectId: 'mobila-app-fd10e',
    authDomain: 'mobila-app-fd10e.firebaseapp.com',
    storageBucket: 'mobila-app-fd10e.firebasestorage.app',
    measurementId: 'G-KP8QEV0W81',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCRO6iAE8a2zDeDqNKwrdSoysZVajr-Jb8',
    appId: '1:38104863071:android:8d9394b4ca593bc53c26ea',
    messagingSenderId: '38104863071',
    projectId: 'mobila-app-fd10e',
    storageBucket: 'mobila-app-fd10e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAcOjOCAF6GndwED61krL9TlD4z7O_oUsk',
    appId: '1:38104863071:ios:4c8b21750f993c713c26ea',
    messagingSenderId: '38104863071',
    projectId: 'mobila-app-fd10e',
    storageBucket: 'mobila-app-fd10e.firebasestorage.app',
    iosBundleId: 'com.example.campusConnect',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAcOjOCAF6GndwED61krL9TlD4z7O_oUsk',
    appId: '1:38104863071:ios:4c8b21750f993c713c26ea',
    messagingSenderId: '38104863071',
    projectId: 'mobila-app-fd10e',
    storageBucket: 'mobila-app-fd10e.firebasestorage.app',
    iosBundleId: 'com.example.campusConnect',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBtPhAmjOiAEJ5pCqIQblL1e5x9bRP0blU',
    appId: '1:38104863071:web:52a55ae3aaed5a2c3c26ea',
    messagingSenderId: '38104863071',
    projectId: 'mobila-app-fd10e',
    authDomain: 'mobila-app-fd10e.firebaseapp.com',
    storageBucket: 'mobila-app-fd10e.firebasestorage.app',
    measurementId: 'G-3YD9FY5G16',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'YOUR_LINUX_API_KEY',
    appId: 'YOUR_LINUX_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );
}