# Campus Connect (INFT 425 Week 8/9 Capstone Integration)

Campus Connect is a social-style mobile app for Valley View University students. It integrates key topics from Weeks 2–9: UI/layouts, navigation, state management with Provider, local persistence, Firebase Authentication, Firestore, REST API integration, camera, and GPS location.

## Features Implemented

- Firebase Email/Password authentication (sign in + sign up + logout)
- Home screen with motivational quote fetched from public REST API
- Firestore-backed campus events (real-time stream)
- Add new event with title, description, date, optional camera image path, optional GPS coordinates
- Event likes with local persistence using SharedPreferences
- Event comments stored in Firestore
- Navigation across login, home, events, add-event, profile, and comments screens
- MVVM folder structure using `models`, `services`, `viewmodels`, `screens`, `widgets`

## Project Structure

lib/
├── main.dart
├── firebase_options.dart
├── models/
│   ├── event.dart
│   └── quote.dart
├── services/
│   ├── auth_service.dart
│   ├── event_service.dart
│   └── quote_service.dart
├── viewmodels/
│   ├── auth_viewmodel.dart
│   ├── event_viewmodel.dart
│   └── quote_viewmodel.dart
├── screens/
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── event_list_screen.dart
│   ├── add_event_screen.dart
│   ├── profile_screen.dart
│   └── comment_screen.dart
└── widgets/
	├── custom_button.dart
	└── loading_indicator.dart

## Firebase Setup

1. Create a Firebase project in Firebase Console.
2. Enable Authentication → Sign-in method → Email/Password.
3. Create a Firestore database.
4. Add Android/iOS/Web apps in Firebase project settings.
5. Replace placeholder values in `lib/firebase_options.dart` with your real Firebase config.
6. (Android) Put `google-services.json` in `android/app/`.
7. (iOS) Put `GoogleService-Info.plist` in `ios/Runner/`.
8. Run:

```bash
flutter pub get
flutter run
```

### Secure API Key Setup (Secret Scanning Safe)

This project now expects Firebase API keys through `--dart-define` instead of hardcoding keys in source code.

Example run command:

```bash
flutter run -d chrome \
	--dart-define=FIREBASE_WEB_API_KEY=YOUR_WEB_API_KEY \
	--dart-define=FIREBASE_ANDROID_API_KEY=YOUR_ANDROID_API_KEY \
	--dart-define=FIREBASE_IOS_API_KEY=YOUR_IOS_API_KEY \
	--dart-define=FIREBASE_MACOS_API_KEY=YOUR_MACOS_API_KEY \
	--dart-define=FIREBASE_WINDOWS_API_KEY=YOUR_WINDOWS_API_KEY \
	--dart-define=FIREBASE_LINUX_API_KEY=YOUR_LINUX_API_KEY
```

## Firestore Data Model

Collection: `events`

Each document contains:
- `id`
- `title`
- `description`
- `date` (ISO string)
- `imageUrl` (optional)
- `latitude` and `longitude` (optional)
- `createdBy` (user UID)
- `likes` (list of user IDs)
- `comments` (array of maps with userId, userName, text, timestamp)

## Device Permissions Notes

- Camera uses `image_picker`.
- Location uses `geolocator`.
- Ensure platform-specific permissions are configured in Android Manifest and iOS Info.plist for production use.

## Challenges Faced

- Keeping UI state and Firestore real-time updates synchronized.
- Handling Firebase initialization and auth state in a Provider-based architecture.
- Supporting local persistence for likes while still syncing like counts with Firestore.

## How to Submit

1. Create public repo: `INFT425_CampusConnect_YourName`
2. Push code with at least 5 meaningful commits.
3. Include this README.
4. Submit repo URL to the course assistant before deadline.
