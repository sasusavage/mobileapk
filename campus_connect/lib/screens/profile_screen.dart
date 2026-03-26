import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final user = authViewModel.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 46,
                child: Text(
                  user?.email?.substring(0, 1).toUpperCase() ?? 'U',
                  style: const TextStyle(fontSize: 28),
                ),
              ),
              const SizedBox(height: 12),
              Text(user?.email ?? 'No email available'),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () async {
                  await authViewModel.signOut();
                  if (!context.mounted) return;
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (_) => false,
                  );
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
