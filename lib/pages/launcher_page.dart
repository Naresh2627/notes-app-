import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';

class LauncherPage extends StatelessWidget {
  const LauncherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Apps'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => context.read<ThemeProvider>().toggleTheme(context),
            icon: Icon(
              isDark ? Icons.wb_sunny_outlined : Icons.nights_stay_outlined,
            ),
          ),
          IconButton(
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  if (context.watch<AuthProvider>().role == 'admin')
                    _buildAppIcon(
                      context,
                      title: 'Notes',
                      icon: Icons.notes,
                      onTap: () {
                        Navigator.pushNamed(context, '/home');
                      },
                    ),
                  _buildAppIcon(
                    context,
                    title: 'Calculator',
                    icon: Icons.calculate,
                    onTap: () {
                      Navigator.pushNamed(context, '/calculator');
                    },
                  ),
                  _buildAppIcon(
                    context,
                    title: 'Stopwatch',
                    icon: Icons.timer,
                    onTap: () {
                      Navigator.pushNamed(context, '/stopwatch');
                    },
                  ),
                  if (context.watch<AuthProvider>().role == 'admin')  
                  _buildAppIcon(
                    context,
                    title: 'Admin Access',
                    icon: Icons.admin_panel_settings,
                    onTap: () {
                      Navigator.pushNamed(context, '/admin_access');
                    },
                  ),
                  _buildAppIcon(
                    context,
                    title: 'Map',
                    icon: Icons.map,
                    onTap: () {
                      Navigator.pushNamed(context, '/map');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppIcon(BuildContext context, {required String title, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                size: 40,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ],
      ),
    );
  }
}
