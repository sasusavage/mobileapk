import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/event_viewmodel.dart';
import '../viewmodels/quote_viewmodel.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quoteViewModel = Provider.of<QuoteViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final eventViewModel = Provider.of<EventViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Campus Connect')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quote of the Day',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  if (quoteViewModel.isLoading)
                    const LoadingIndicator()
                  else if (quoteViewModel.errorMessage != null)
                    const Text('Failed to load quote.')
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '"${quoteViewModel.currentQuote?.text ?? 'No quote yet'}"',
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '- ${quoteViewModel.currentQuote?.author ?? 'Unknown'}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: quoteViewModel.loadRandomQuote,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('New Quote'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final userId = authViewModel.user?.uid ?? '';
                      await eventViewModel.seedSampleEventsIfEmpty(userId);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Demo events seeded (if database was empty).'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.cloud_download_outlined),
                    label: const Text('Seed Demo Data'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          CustomButton(
            label: 'View Events',
            icon: Icons.event_note_rounded,
            onPressed: () => Navigator.pushNamed(context, '/events'),
          ),
          const SizedBox(height: 10),
          CustomButton(
            label: 'My Profile',
            icon: Icons.person_rounded,
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
    );
  }
}
