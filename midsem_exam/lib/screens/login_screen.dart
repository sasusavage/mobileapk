import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/student.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password.')),
      );
      return;
    }

    debugPrint('Email: $email | Password: $password');

    setState(() {
      _isLoading = true;
    });

    // Attempt Firebase Auth; fall back to demo mode if Firebase is not yet
    // configured (placeholder firebase_options.dart values).
    bool firebaseSuccess = false;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      firebaseSuccess = true;
    } on FirebaseAuthException {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        firebaseSuccess = true;
      } on FirebaseAuthException catch (error) {
        debugPrint('FirebaseAuth error code: ${error.code} | ${error.message}');
        // Continue in demo mode — show a non-blocking warning.
        if (mounted) {
          final reason = switch (error.code) {
            'operation-not-allowed' =>
              'Enable Email/Password in Firebase Console → Auth → Sign-in method.',
            'user-not-found' => 'No account found. Creating one…',
            'wrong-password' => 'Wrong password.',
            'network-request-failed' => 'No internet connection.',
            _ => 'Auth error (${error.code}). Running in demo mode.',
          };
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(reason),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Firebase unavailable: $e');
    }

    debugPrint('Firebase auth success: $firebaseSuccess');

    if (!mounted) return;

    final student = const Student(
      name: 'Ama Mensah',
      id: 'VVU/CSC/24/1031',
      course: 'BSc Computer Science',
    );

    Navigator.pushReplacementNamed(
      context,
      '/profile',
      arguments: student,
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              // ── Logo ──────────────────────────────────────────────
              Center(
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.school_rounded,
                      size: 48, color: cs.primary),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Valley View University',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Student Portal',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 40),
              // ── Email ─────────────────────────────────────────────
              TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email address',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.4),
              ),
            ),
              const SizedBox(height: 14),
              // ── Password ──────────────────────────────────────────
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () => setState(
                        () => _obscurePassword = !_obscurePassword),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor:
                      cs.surfaceContainerHighest.withValues(alpha: 0.4),
                ),
              ),
              const SizedBox(height: 28),
              // ── Sign In Button ────────────────────────────────────
              FilledButton(
                onPressed: _isLoading ? null : _signIn,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Sign In',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'VVU Student Profile & Task Manager',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.5),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
