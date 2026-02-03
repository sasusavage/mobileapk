import 'package:flutter/material.dart';
import 'models/portfolio_data.dart';
import 'screens/portfolio_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final myData = PortfolioData(
      name: "SASU", // Customize this
      title: "300 Level Computer Science Student",
      bio: "Aspiring developer focused on building professional mobile applications.",
      skills: ["Flutter", "Dart", "Git", "PHP", "Python"],
      education: [Education(institution: "Valley View University", degree: "BSc. Computer Science", year: "2023-Present")],
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: PortfolioScreen(data: myData),
    );
  }
}