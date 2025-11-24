import 'package:flutter/material.dart';
import 'package:schedsync_app/Profile/profile_screen.dart';
import 'package:schedsync_app/model/base_app_user.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
//final calendarController = HorizontalCalendarController();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
var selectedDate = DateTime.now();

  // CONFIRM LOGOUT
  // Future<void> _confirmLogout(BuildContext context) async {
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: Text(
  //         'Logout confirmation',
  //         style: Theme.of(context).textTheme.titleMedium!.copyWith(
  //               fontWeight: FontWeight.bold,
  //             ),
  //       ),
  //       content: Text(
  //         'Are you sure you want to logout?',
  //         style: Theme.of(context).textTheme.titleMedium,
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(ctx),
  //           child: const Text('Cancel'),
  //         ),
  //         TextButton(
  //           onPressed: () async {
  //             Navigator.pop(ctx);
  //             await Future.delayed(const Duration(milliseconds: 300));
  //             widget.logout();
  //           },
  //           child: const Text('Yes'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Placeholder widgets for the nav bar pages
  final List<Widget> _pages = [
    const Center(child: Text("Dashboard Page")),
    const Center(child: Text("Add Schedule")),
    const Center(child: Text("Classes Page")),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/img/smallLogo.png', 
              height: 36,
              color: isDark ? Colors.white : null,
              colorBlendMode: BlendMode.srcIn,
              ),
            Text(' SchedSync'),
          ],
        ),
        //const Text('SchedSync'),
        actions: [
          IconButton(
            onPressed: widget.switchTheme,
            icon: const Icon(Icons.brightness_6),
          ),
          // IconButton(
          //   onPressed: () => _confirmLogout(context),
          //   icon: const Icon(Icons.logout),
          // ),
          IconButton(
         onPressed: () {
           Navigator.of(context).push(
           MaterialPageRoute(
           builder: (_) => ProfilePage(
           widget.switchTheme,
           currentUser: widget.currentUser,
           logout: widget.logout,
           goToHome: () { //setState(() { _selectedIndex = 0; 
          //}); 
          },
        ),
      ),
    );
  },
  icon: const Icon(Icons.person),
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

  return Padding(
    padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TODAY',
            style: TextStyle(
                  color: Colors.lightGreen,
                  fontSize: 30,
                ),
            textAlign: TextAlign.left,
          ),
          Text(
            DateFormat('dd MMMM, yyyy').format(DateTime.now()),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: textColor,
                ),
            textAlign: TextAlign.left,
          ),
           const SizedBox(height: 8),
            Text(
            '1 Exam | 2 Submissions',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: textColor,
                  fontSize: 18,
                ),
            textAlign: TextAlign.left,
          ),
          // Text(
          //   'Welcome, ${widget.currentUser.firstName} ${widget.currentUser.lastName}!',
          //   style: Theme.of(context).textTheme.titleLarge!.copyWith(
          //         color: textColor,
          //       ),
          //   textAlign: TextAlign.left,
          // ),
          // const SizedBox(height: 16),
          // Text(
          //   'Username: ${widget.currentUser.username}',
          //   style: Theme.of(context).textTheme.titleMedium!.copyWith(
          //         color: textColor,
          //       ),
          // ),
          // const SizedBox(height: 8),
          // Text(
          //   'User ID: ${widget.currentUser.uuid}',
          //   style: Theme.of(context).textTheme.titleMedium!.copyWith(
          //         color: textColor,
          //       ),
          // ),
           const SizedBox(height: 15),
          Expanded(
          child: SfCalendar(
            view: CalendarView.week,
            todayHighlightColor: Theme.of(context).colorScheme.onBackground,
            showCurrentTimeIndicator: false,
            headerHeight: 0,

            timeSlotViewSettings: const TimeSlotViewSettings(
              startHour: 6,
              endHour: 22,
              timeIntervalHeight: 70,
              timeFormat: 'h:mm a',
            ),
          ),
        ),
        ],
      ),
  );
}
}

