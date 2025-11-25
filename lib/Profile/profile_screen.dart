import 'package:flutter/material.dart';
import 'package:schedsync_app/model/base_app_user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage(
    this.switchTheme, {
    super.key,
    required this.currentUser,
    required this.logout,
    required this.goToHome,
  });

  final void Function() switchTheme;
  final  VoidCallback goToHome;
  final VoidCallback logout;
  final BaseAppUser currentUser;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

// CONFIRM LOGOUT
  Future<void> _confirmLogout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Logout confirmation',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await Future.delayed(const Duration(milliseconds: 300));
              widget.logout();
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
   return Scaffold(
    appBar: AppBar(
      title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            widget.goToHome();
            Navigator.pop(context);
            }
        ),
        actions: [
          IconButton(
            onPressed: widget.switchTheme,
            icon: const Icon(Icons.brightness_6),
          ),
        ],
    ),

    body: Column(
    children: [
      // PROFILE ICON
      const CircleAvatar(
        backgroundColor: Colors.black,
        radius: 50,
        child: Icon(Icons.person, size: 80, color: Colors.white,),
      ),
      const SizedBox(height: 10),

      // USER NAME
      Text(
        '${widget.currentUser.firstName} ${widget.currentUser.lastName}',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),

      // EMAIL
      Text(
        widget.currentUser.username,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
          fontSize: 18,
        ),
      ),
      const SizedBox(height: 15),

      // EDIT BUTTON
      OutlinedButton.icon(
        onPressed: () {
          
        },
        icon: const Icon(Icons.edit, size: 16),
        label: const Text("Edit"),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),

      const Spacer(),

      // LOGOUT BUTTON
      Align(
        alignment: Alignment.bottomRight,
        child: OutlinedButton.icon(
          onPressed: () => _confirmLogout(context),
          icon: const Icon(Icons.logout, size: 16),
          label: const Text("Logout"),
        ),
      ),
      const SizedBox(height: 10),

    ],
  
),


   

   );
  }
}