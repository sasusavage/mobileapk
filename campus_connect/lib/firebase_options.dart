import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

const String _webApiKey =
  String.fromEnvironment('FIREBASE_WEB_API_KEY', defaultValue: 'REDACTED');
const String _androidApiKey = String.fromEnvironment(
  'FIREBASE_ANDROID_API_KEY',
  defaultValue: 'REDACTED',
);
const String _iosApiKey =
  String.fromEnvironment('FIREBASE_IOS_API_KEY', defaultValue: 'REDACTED');
const String _macosApiKey =
  String.fromEnvironment('FIREBASE_MACOS_API_KEY', defaultValue: 'REDACTED');
const String _windowsApiKey = String.fromEnvironment(
  'FIREBASE_WINDOWS_API_KEY',
  defaultValue: 'REDACTED',
);
const String _linuxApiKey =
  String.fromEnvironment('FIREBASE_LINUX_API_KEY', defaultValue: 'REDACTED');

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
    apiKey: _webApiKey,
    appId: '1:38104863071:web:e16ad604d5c8a7bd3c26ea',
    messagingSenderId: '38104863071',
    projectId: 'mobila-app-fd10e',
    authDomain: 'mobila-app-fd10e.firebaseapp.com',
    storageBucket: 'mobila-app-fd10e.firebasestorage.app',
    measurementId: 'G-KP8QEV0W81',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: _androidApiKey,
    appId: '1:38104863071:android:8d9394b4ca593bc53c26ea',
    messagingSenderId: '38104863071',
    projectId: 'mobila-app-fd10e',
    storageBucket: 'mobila-app-fd10e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: _iosApiKey,
    appId: '1:38104863071:ios:4c8b21750f993c713c26ea',
    messagingSenderId: '38104863071',
    projectId: 'mobila-app-fd10e',
    storageBucket: 'mobila-app-fd10e.firebasestorage.app',
    iosBundleId: 'com.example.campusConnect',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: _macosApiKey,
    appId: '1:38104863071:ios:4c8b21750f993c713c26ea',
    messagingSenderId: '38104863071',
    projectId: 'mobila-app-fd10e',
    storageBucket: 'mobila-app-fd10e.firebasestorage.app',
    iosBundleId: 'com.example.campusConnect',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: _windowsApiKey,
    appId: '1:38104863071:web:52a55ae3aaed5a2c3c26ea',
    messagingSenderId: '38104863071',
    projectId: 'mobila-app-fd10e',
    authDomain: 'mobila-app-fd10e.firebaseapp.com',
    storageBucket: 'mobila-app-fd10e.firebasestorage.app',
    measurementId: 'G-3YD9FY5G16',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: _linuxApiKey,
    appId: 'YOUR_LINUX_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );
}