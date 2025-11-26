import 'package:flutter/material.dart';
import 'package:schedsync_app/model/base_app_user.dart';
import 'package:schedsync_app/Profile/edit_profile_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage(
    this.switchTheme, {
    super.key,
    required this.currentUser,
    required this.logout,
    required this.goToHome,
  });

  final void Function() switchTheme;
  final VoidCallback goToHome;
  final VoidCallback logout;
  final BaseAppUser currentUser;

  Future<void> _confirmLogout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout confirmation'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              logout();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onBackground;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            goToHome();
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: switchTheme,
            icon: const Icon(Icons.brightness_6),
          ),
        ],
      ),

      body: Column(
        children: [
          const SizedBox(height: 16),

          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.black,
            child: Icon(Icons.person, size: 80, color: Colors.white),
          ),

          const SizedBox(height: 12),

          Text(
            "${currentUser.firstName} ${currentUser.lastName}",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),

          Text(
            currentUser.email,
            style: TextStyle(fontSize: 16, color: color),
          ),

          const SizedBox(height: 20),

          OutlinedButton.icon(
            icon: const Icon(Icons.edit, size: 16),
            label: const Text("Edit"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfile(
                    currentUser: currentUser,
                  ),
                ),
              );
            },
          ),

          const Spacer(),

          OutlinedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
            onPressed: () => _confirmLogout(context),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
