import 'package:flutter/material.dart';
import 'package:schedsync_app/model/base_app_user.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({
    super.key,
    required this.currentUser,
  });

  final BaseAppUser currentUser;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onBackground;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile (Test Mode)"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 80),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              "User ID:",
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
            Text(currentUser.userId, style: TextStyle(color: textColor)),
            const SizedBox(height: 16),

            Text(
              "Email:",
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
            Text(currentUser.email, style: TextStyle(color: textColor)),
            const SizedBox(height: 16),

            Text(
              "First Name:",
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
            Text(currentUser.firstName, style: TextStyle(color: textColor)),
            const SizedBox(height: 16),

            Text(
              "Last Name:",
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
            Text(currentUser.lastName, style: TextStyle(color: textColor)),
            const SizedBox(height: 40),

            Center(
              child: Text(
                "Profile editing is disabled.\nTesting login + register only.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
