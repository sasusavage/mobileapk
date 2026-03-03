import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/departments_screen.dart';
import 'screens/department_detail.dart';

void main() {
  runApp(const VVUCampusDirectoryApp());
}

/// Main Application Widget for VVU Campus Directory
class VVUCampusDirectoryApp extends StatelessWidget {
  const VVUCampusDirectoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VVU Campus Directory',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      // Define Named Routes
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/departments': (context) => const DepartmentsScreen(),
        '/details': (context) => const DepartmentDetailScreen(),
      },
    );
  }
}
