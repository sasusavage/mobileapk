import 'package:flutter/material.dart';
import '../data/campus_data.dart';
import '../models/department.dart';

/// Departments List Screen - displays all VVU departments
class DepartmentsScreen extends StatelessWidget {
  const DepartmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VVU Departments'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: vvuDepartments.length,
        itemBuilder: (context, index) {
          final Department department = vvuDepartments[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  _getDepartmentIcon(department.name),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              title: Text(
                department.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                department.building,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/details',
                  arguments: department,
                );
              },
            ),
          );
        },
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
