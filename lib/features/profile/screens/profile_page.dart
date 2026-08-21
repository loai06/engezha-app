import 'package:flutter/material.dart';

import '../../../app/theme/theme_controller.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../models/user_profile.dart';
import '../widgets/profile_data.dart';
import '../widgets/profile_item.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: StreamBuilder<UserProfile>(
        stream: FirestoreService.instance.watchProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final authUser = AuthService.instance.currentUser;
          final profile = snapshot.data ??
              UserProfile(
                uid: authUser?.uid ?? '',
                name: authUser?.displayName ?? 'Engezha User',
                email: authUser?.email ?? '',
              );

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
            children: [
              CircleAvatar(
                radius: 48,
                child: Text(
                  _initials(profile.name),
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 24),
              ProfileData(label: 'Name', value: profile.name),
              const Divider(height: 28),
              ProfileData(label: 'Email', value: profile.email),
              const SizedBox(height: 20),
              ProfileItem(
                icon: Icons.lock_reset_rounded,
                title: 'Reset Password',
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _resetPassword(context),
              ),
              ProfileItem(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Theme',
                trailing: Switch(
                  value: themeController.darkMode,
                  onChanged: themeController.setDarkMode,
                ),
                onTap: () =>
                    themeController.setDarkMode(!themeController.darkMode),
              ),
              const SizedBox(height: 28),
              OutlinedButton.icon(
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Log Out'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _resetPassword(BuildContext context) async {
    try {
      await AuthService.instance.sendPasswordReset(
        email: AuthService.instance.currentUser?.email ?? '',
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent.')),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AuthService.instance.messageFor(error))),
      );
    }
  }

  Future<void> _logout(BuildContext context) async {
    await AuthService.instance.signOut();
    if (!context.mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  static String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'E';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
