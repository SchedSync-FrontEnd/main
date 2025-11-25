import 'package:flutter/material.dart';
import 'package:schedsync_app/Profile/profile_screen.dart';
import 'package:schedsync_app/class/class_screen.dart';
import 'package:schedsync_app/model/base_app_user.dart';
import 'package:intl/intl.dart';
import 'package:schedsync_app/model/exam_model.dart';
import 'package:schedsync_app/model/submission_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:schedsync_app/home/add_tab.dart';

// Assuming the current user ID is 'u1' for testing the dashboard count
const String UserId = 'u1'; 

final List<ExamModel> allDummyExams = [
  // Exam for the current user ('u1')
  ExamModel(
    examId: 'e1', userId: UserId, classId: 'c1', 
    examTitle: 'Physics Exam', description: '', 
    examDate: '2025-11-29', deadline: '2025-11-29', status: 'Pending',
  ),
  ExamModel(
    examId: 'e2', userId: UserId, classId: 'c2', 
    examTitle: 'History Final', description: '', 
    examDate: '2025-12-10', deadline: '2025-12-10', status: 'Pending',
  ),
];

final List<SubmissionModel> allDummySubmissions = [
  // Submission for the current user
  SubmissionModel(
    submissionId: 's1', userId: UserId, classId: 'c1',
    title: 'Kinematics Homework', description: '', 
    submissionDate: '2025-11-28', deadline: '2025-11-28', status: 'Pending',
  ),
  SubmissionModel(
    submissionId: 's2', userId: UserId, classId: 'c1',
    title: 'Lab Report 1', description: '', 
    submissionDate: '2025-11-30', deadline: '2025-11-30', status: 'Pending',
  ),
  SubmissionModel(
    submissionId: 's3', userId: UserId, classId: 'c4',
    title: 'Bio Project', description: '', 
    submissionDate: '2025-12-01', deadline: '2025-12-01', status: 'Pending',
  ),
];


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
  var selectedDate = DateTime.now();

  // Placeholder widgets for the nav bar pages
  final List<Widget> _pages = [
    const Center(child: Text("Dashboard Page")),
    const Center(child: Text("Add Schedule")),
    const ClassScreen(), 
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
                    goToHome: () {
                      //setState(() { _selectedIndex = 0;
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

      body: _selectedIndex == 0 ? _buildHomeContent() : _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
  currentIndex: _selectedIndex,
  onTap: (i) async {
    if (i == 1) {
      // Add button: show the popup
      await showAddTabDialog(context);
      return;
    }
    setState(() => _selectedIndex = i); // Home (0) or Classes (2)
  }, 
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

    // Filter exams/submissions relevant to the current user 
    final userExams = allDummyExams
        .where((e) => e.userId == widget.currentUser.userId)
        .toList();

    final userSubmissions = allDummySubmissions
        .where((s) => s.userId == widget.currentUser.userId)
        .toList();
        
    final examCount = userExams.length;
    final submissionCount = userSubmissions.length;
    
    final examText = examCount == 1 ? 'Exam' : 'Exams';
    final submissionText = submissionCount == 1 ? 'Submission' : 'Submissions';
    

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TODAY',
            style: TextStyle(color: Colors.lightGreen, fontSize: 30),
            textAlign: TextAlign.left,
          ),
          Text(
            DateFormat('dd MMMM, yyyy').format(DateTime.now()),
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(color: textColor),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 8),
          Text(
            '${examCount} $examText | ${submissionCount} $submissionText',
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(color: textColor, fontSize: 18),
            textAlign: TextAlign.left,
          ),
          // Text(
          //   '1 Exam | 2 Submissions',
          //   style: Theme.of(
          //     context,
          //   ).textTheme.titleMedium!.copyWith(color: textColor, fontSize: 18),
          //   textAlign: TextAlign.left,
          // ),
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
