import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../app/theme/theme_controller.dart';
import '../widgets/profile_data.dart';
import '../widgets/profile_item.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        children: [
          const CircleAvatar(
            radius: 48,
            child: Icon(Icons.person_rounded, size: 58),
          ),
          const SizedBox(height: 24),
          const ProfileData(label: 'Name', value: 'John Doe'),
          const Divider(height: 28),
          const ProfileData(label: 'Email', value: 'johndoe@email.com'),
          const SizedBox(height: 20),
          ProfileItem(
            icon: Icons.lock_outline_rounded,
            title: 'Edit Password',
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          ProfileItem(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Theme',
            trailing: Switch(
              value: themeController.darkMode,
              onChanged: themeController.setDarkMode,
            ),
            onTap: () => themeController.setDarkMode(
              !themeController.darkMode,
            ),
          ),
          ProfileItem(
            icon: Icons.language_rounded,
            title: 'Language',
            trailing: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('English'),
                Icon(Icons.chevron_right_rounded),
              ],
            ),
            onTap: () {},
          ),
          const SizedBox(height: 28),
          OutlinedButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) => false,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
