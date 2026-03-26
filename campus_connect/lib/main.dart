import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/add_event_screen.dart';
import 'screens/comment_screen.dart';
import 'screens/event_list_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/event_viewmodel.dart';
import 'viewmodels/quote_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CampusConnectApp());
}

class CampusConnectApp extends StatelessWidget {
  const CampusConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => EventViewModel()),
        ChangeNotifierProvider(create: (_) => QuoteViewModel()..loadRandomQuote()),
      ],
      child: MaterialApp(
        title: 'Campus Connect',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        routes: {
          '/login': (_) => const LoginScreen(),
          '/home': (_) => const HomeScreen(),
          '/events': (_) => const EventListScreen(),
          '/add-event': (_) => const AddEventScreen(),
          '/profile': (_) => const ProfileScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/comments') {
            final eventId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => CommentScreen(eventId: eventId),
            );
          }
          return null;
        },
        home: Consumer<AuthViewModel>(
          builder: (context, authViewModel, _) {
            return authViewModel.user == null
                ? const LoginScreen()
                : const HomeScreen();
          },
        ),
      ),
    );
  }
}
