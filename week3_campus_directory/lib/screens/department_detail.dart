import 'package:flutter/material.dart';
import '../models/department.dart';

/// Department Detail Screen - StatefulWidget with expandable sections
class DepartmentDetailScreen extends StatefulWidget {
  const DepartmentDetailScreen({super.key});

  @override
  State<DepartmentDetailScreen> createState() => _DepartmentDetailScreenState();
}

class _DepartmentDetailScreenState extends State<DepartmentDetailScreen> {
  /// State variable to track if department is marked as favorite
  bool _isFavorite = false;

  /// State variables for expandable sections
  bool _isAboutExpanded = true;
  bool _isLocationExpanded = false;
  bool _isContactExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Retrieve the Department object passed as an argument via Named Routes
    final Department department =
        ModalRoute.of(context)!.settings.arguments as Department;

    return Scaffold(
      appBar: AppBar(
        title: Text(department.name),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          // Favorite toggle IconButton
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
              // Show feedback to user
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isFavorite
                        ? '${department.name} added to favorites!'
                        : '${department.name} removed from favorites.',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            tooltip: _isFavorite ? 'Remove from favorites' : 'Add to favorites',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Department Header with Icon
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getDepartmentIcon(department.name),
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Department Name
          Center(
            child: Text(
              department.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),

          // Expandable About Section
          Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              leading: Icon(
                Icons.description,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                'About',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              initiallyExpanded: _isAboutExpanded,
              onExpansionChanged: (expanded) {
                setState(() {
                  _isAboutExpanded = expanded;
                });
              },
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    department.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),

          // Expandable Location Section
          Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              leading: Icon(
                Icons.location_on,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                'Location',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              initiallyExpanded: _isLocationExpanded,
              onExpansionChanged: (expanded) {
                setState(() {
                  _isLocationExpanded = expanded;
                });
              },
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Row(
                    children: [
                      const Icon(Icons.business, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          department.building,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Expandable Contact Section
          Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              leading: Icon(
                Icons.phone,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                'Contact',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              initiallyExpanded: _isContactExpanded,
              onExpansionChanged: (expanded) {
                setState(() {
                  _isContactExpanded = expanded;
                });
              },
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Row(
                    children: [
                      const Icon(Icons.call, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        department.contact,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Back Button
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back to Departments'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  /// Returns an appropriate icon based on department name
  IconData _getDepartmentIcon(String departmentName) {
    switch (departmentName.toLowerCase()) {
      case 'computer science':
        return Icons.computer;
      case 'nursing':
        return Icons.local_hospital;
      case 'business administration':
        return Icons.business;
      case 'theology':
        return Icons.church;
      case 'social work':
        return Icons.people;
      default:
        return Icons.school;
    }
  }
}