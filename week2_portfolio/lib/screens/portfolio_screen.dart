import 'package:flutter/material.dart';
import '../models/portfolio_data.dart';

class PortfolioScreen extends StatelessWidget {
  final PortfolioData data;
  const PortfolioScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Mandatory: AppBar with your name
      appBar: AppBar(
        title: Text('Professional Portfolio - ${data.name}'), 
        elevation: 4,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Mandatory: Tablet Layout (>= 600px)
          if (constraints.maxWidth >= 600) {
            return Row(
              children: [
                Expanded(flex: 1, child: _buildProfileHeader(context)),
                Expanded(flex: 2, child: _buildDetailsSection(context)),
              ],
            );
          } else {
            // Mandatory: Mobile Layout (< 600px)
            return SingleChildScrollView(
              child: _buildDetailsSection(context),
            );
          }
        },
      ),
    );
  }

  // Pass BuildContext here to fix the "context isn't defined" error
  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Mandatory: Profile image using CircleAvatar
        const CircleAvatar(
          radius: 60,
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.person, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 16),
        Text(
          data.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          data.title,
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show header inside the column only for mobile
          if (MediaQuery.of(context).size.width < 600) ...[
            _buildProfileHeader(context),
            const Divider(height: 32),
          ],
          
          // Mandatory: Bio section using a Card with elevation
          const Text("About Me", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(data.bio),
            ),
          ),
          
          const SizedBox(height: 20),
          const Text("Skills", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          // Mandatory: List of 5+ skills using Chips
          Wrap(
            spacing: 8,
            children: data.skills.map((skill) => Chip(
              label: Text(skill),
              backgroundColor: Colors.blue[50],
            )).toList(),
          ),
          
          const SizedBox(height: 20),
          const Text("Academic History", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          // Mandatory: ListView/Column for Academic History
          ...data.education.map((edu) => ListTile(
            leading: const Icon(Icons.school),
            title: Text(edu.institution),
            subtitle: Text("${edu.degree} (${edu.year})"),
          )).toList(),
        ],
      ),
    );
  }
}