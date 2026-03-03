import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoggingOut = false;

  // Get current user
  User? get _user => FirebaseAuth.instance.currentUser;

  // Format date for display
  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  // Logout function with confirmation
  Future<void> _logout() async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      setState(() => _isLoggingOut = true);
      try {
        await FirebaseAuth.instance.signOut();
        // AuthWrapper will automatically redirect to login
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logout failed: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() => _isLoggingOut = false);
        }
      }
    }
  }

  // Handle dashboard tile tap
  void _handleTileTap(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title - Coming soon!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
        centerTitle: true,
        elevation: 0,
        actions: [
          // Logout button in app bar
          _isLoggingOut
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Logout',
                  onPressed: _logout,
                ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message section
              _buildWelcomeSection(),
              const SizedBox(height: 24),

              // User information card
              _buildUserInfoCard(),
              const SizedBox(height: 24),

              // Dashboard title
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),

              // Dashboard tiles grid
              _buildDashboardGrid(),
            ],
          ),
        ),
      ),
    );
  }

  // Welcome section with user greeting
  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // User avatar
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 40,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome,',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  _user?.displayName ?? _user?.email?.split('@').first ?? 'User',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // User information card
  Widget _buildUserInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Account Information',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),

            // Email row
            _buildInfoRow(
              'Email',
              _user?.email ?? 'Not available',
              Icons.email_outlined,
            ),
            const Divider(),

            // User ID row
            _buildInfoRow(
              'User ID',
              _user?.uid ?? 'Not available',
              Icons.fingerprint,
            ),
            const Divider(),

            // Email verification status
            _buildInfoRow(
              'Email Verified',
              _user?.emailVerified == true ? 'Yes ✓' : 'No ✗',
              Icons.verified_user_outlined,
              valueColor: _user?.emailVerified == true
                  ? Colors.green
                  : Colors.orange,
            ),
            const Divider(),

            // Account creation date
            _buildInfoRow(
              'Account Created',
              _formatDate(_user?.metadata.creationTime),
              Icons.calendar_today_outlined,
            ),
            const Divider(),

            // Last sign in
            _buildInfoRow(
              'Last Sign In',
              _formatDate(_user?.metadata.lastSignInTime),
              Icons.access_time,
            ),
          ],
        ),
      ),
    );
  }

  // Info row widget for user card
  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  // Dashboard grid with tiles
  Widget _buildDashboardGrid() {
    final tiles = [
      _DashboardTileData(
        icon: Icons.person,
        label: 'Profile',
        color: Colors.blue,
      ),
      _DashboardTileData(
        icon: Icons.settings,
        label: 'Settings',
        color: Colors.grey,
      ),
      _DashboardTileData(
        icon: Icons.history,
        label: 'History',
        color: Colors.orange,
      ),
      _DashboardTileData(
        icon: Icons.help_outline,
        label: 'Help',
        color: Colors.green,
      ),
      _DashboardTileData(
        icon: Icons.notifications_outlined,
        label: 'Notifications',
        color: Colors.purple,
      ),
      _DashboardTileData(
        icon: Icons.security,
        label: 'Security',
        color: Colors.red,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: tiles.length,
      itemBuilder: (context, index) {
        return _buildDashboardTile(tiles[index]);
      },
    );
  }

  // Individual dashboard tile widget
  Widget _buildDashboardTile(_DashboardTileData data) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _handleTileTap(data.label),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: data.color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  data.icon,
                  size: 32,
                  color: data.color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                data.label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Data class for dashboard tiles
class _DashboardTileData {
  final IconData icon;
  final String label;
  final Color color;

  _DashboardTileData({
    required this.icon,
    required this.label,
    required this.color,
  });
}
