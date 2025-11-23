import 'package:flutter/material.dart';
import 'package:schedsync_app/model/base_app_user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
    this.switchTheme, {
    super.key,
    required this.currentUser,
    required this.logout,
  });

  final void Function() switchTheme;
  final VoidCallback logout;
  final BaseAppUser currentUser;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

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
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  // Placeholder widgets for the nav bar pages
  final List<Widget> _pages = [
    const Center(child: Text("Dashboard Page")),
    const Center(child: Text("Add Schedule")),
    const Center(child: Text("Classes Page")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: widget.switchTheme,
            icon: const Icon(Icons.brightness_6),
          ),
          IconButton(
            onPressed: () => _confirmLogout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: _selectedIndex == 0
          ? _buildHomeContent()
          : _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Classes',
          ),
        ],
      ),
    );
  }

 Widget _buildHomeContent() {
  final textColor = Theme.of(context).colorScheme.onBackground;

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Welcome, ${widget.currentUser.firstName} ${widget.currentUser.lastName}!',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: textColor,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Username: ${widget.currentUser.username}',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: textColor,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'User ID: ${widget.currentUser.uuid}',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: textColor,
              ),
        ),
      ],
    ),
  );
}

}
