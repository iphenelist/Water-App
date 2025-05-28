import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../services/auth_service.dart';
import 'components/profile_menu_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Cast user to AppUser
    final appUser = user;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(defaultPadding),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Text(
                    appUser.name.isNotEmpty
                        ? appUser.name[0].toUpperCase()
                        : "?",
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  appUser.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  appUser.email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withAlpha(204),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    appUser.userType == UserType.customer
                        ? "Customer"
                        : "Researcher",
                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Account Settings",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: defaultPadding),
                ProfileMenuItem(
                  icon: Icons.person_outline,
                  title: "Edit Profile",
                  onTap: () {
                    // Navigate to edit profile screen
                  },
                ),
                ProfileMenuItem(
                  icon: Icons.notifications_none,
                  title: "Notifications",
                  onTap: () {
                    // Navigate to notifications screen
                  },
                ),
                ProfileMenuItem(
                  icon: Icons.security,
                  title: "Security",
                  onTap: () {
                    // Navigate to security screen
                  },
                ),
                ProfileMenuItem(
                  icon: Icons.language,
                  title: "Language",
                  onTap: () {
                    // Navigate to language screen
                  },
                ),
                const Divider(),
                const SizedBox(height: defaultPadding / 2),
                const Text(
                  "Support",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: defaultPadding),
                ProfileMenuItem(
                  icon: Icons.help_outline,
                  title: "Help Center",
                  onTap: () {
                    // Navigate to help center
                  },
                ),
                ProfileMenuItem(
                  icon: Icons.info_outline,
                  title: "About",
                  onTap: () {
                    // Navigate to about screen
                  },
                ),
                const Divider(),
                const SizedBox(height: defaultPadding),
                ProfileMenuItem(
                  icon: Icons.logout,
                  title: "Logout",
                  color: Colors.red,
                  onTap: () async {
                    await authService.signOut();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, loginScreenRoute);
                    }
                  },
                ),
                const SizedBox(height: defaultPadding),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
