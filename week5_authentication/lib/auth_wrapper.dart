import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // The stream of auth changes
      builder: (context, snapshot) {
        // Show loading while waiting for Firebase
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        // If user object exists, go to Dashboard
        if (snapshot.hasData) {
          return const DashboardScreen();
        }
        // Otherwise, go to Login
        return const LoginScreen();
      },
    );
  }
}