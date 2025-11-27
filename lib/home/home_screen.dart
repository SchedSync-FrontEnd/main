// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:schedsync_app/service/exam_service.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';

// import 'package:schedsync_app/Profile/profile_screen.dart';
// import 'package:schedsync_app/class/class_screen.dart';
// import 'package:schedsync_app/home/add_tab.dart';
// import 'package:schedsync_app/model/base_app_user.dart';
// import 'package:schedsync_app/model/exam_model.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen(
//     this.switchTheme, {
//     super.key,
//     required this.currentUser,
//     required this.logout,
//   });

//   final void Function() switchTheme;
//   final VoidCallback logout;
//   final BaseAppUser currentUser;

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;

//   List<ExamModel> exams = [];
//   bool isLoadingExams = true;
  

//   @override
//   void initState() {
//     super.initState();
//     // _pages = [
//     //         // Index 0: Dashboard (Handled by _buildHomeContent)
//     //         const Center(child: Text("Dashboard Page")), 
            
//     //         // Index 1: Add Schedule (Placeholder; handled by showAddTabDialog in onTap)
//     //         // Note: If 'Add' is ONLY a modal, this page slot is unused in the body, 
//     //         // but we maintain the three-item list to match the three BottomNavigationBarItems.
//     //         const Center(child: Text("Add Schedule")), 
            
//     //         // Index 2: Classes (FIXED: Passing currentUser)
//     //         ClassScreen(), 
//     //     ];

//         _loadExams(); 
//   }

//   Future<void> _loadExams() async {
//     final service = ExamService();
//     final data = await service.getExams(widget.currentUser.userId, context);

//     setState(() {
//       exams = data.map((json) => ExamModel.fromJson(json)).toList();
//       isLoadingExams = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Image.asset(
//               'assets/img/smallLogo.png',
//               height: 36,
//               color: isDark ? Colors.white : null,
//               colorBlendMode: BlendMode.srcIn,
//             ),
//             const Text(' SchedSync'),
//           ],
//         ),
//         actions: [
//           IconButton(
//             onPressed: widget.switchTheme,
//             icon: const Icon(Icons.brightness_6),
//           ),
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => ProfilePage(
//                     widget.switchTheme,
//                     currentUser: widget.currentUser,
//                     logout: widget.logout,
//                     goToHome: () {},
//                   ),
//                 ),
//               );
//             },
//             icon: const Icon(Icons.person),
//           ),
//         ],
//       ),

//       body: _selectedIndex == 0 ? _buildHomeContent() : _pages[_selectedIndex],

//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: (i) async {
//           if (i == 1) {
//             await showAddTabDialog(context);
//             return;
//           }
//           setState(() => _selectedIndex = i);
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Add'),
//           BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), label: 'Classes'),
//         ],
//       ),
//     );
//   }

//   // NEW IMPROVED HOME PAGE UI 

// Widget _buildHomeContent() {
//   final textColor = Theme.of(context).colorScheme.onBackground;

//   return Padding(
//     padding: const EdgeInsets.all(16.0),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // TODAY HEADER
//         Text(
//           'TODAY',
//           style: const TextStyle(
//             color: Colors.lightGreen,
//             fontSize: 30,
//             fontWeight: FontWeight.bold,
//           ),
//         ),

//         Text(
//           DateFormat('dd MMMM, yyyy').format(DateTime.now()),
//           style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                 color: textColor,
//               ),
//         ),

//         const SizedBox(height: 10),

//         // COUNTERS
//         Text(
//           "${exams.length} Exams",
//           style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                 color: textColor,
//                 fontSize: 18,
//               ),
//         ),

//         const SizedBox(height: 12),

//         // TOP: CALENDAR 
//         Expanded(
//           flex: 3,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: SfCalendar(
//               view: CalendarView.week,
//               todayHighlightColor: Theme.of(context).colorScheme.primary,
//               showCurrentTimeIndicator: true,
//               headerHeight: 0,
//               timeSlotViewSettings: const TimeSlotViewSettings(
//                 startHour: 6,
//                 endHour: 22,
//                 timeIntervalHeight: 65,
//                 timeFormat: 'h:mm a',
//               ),
//             ),
//           ),
//         ),

//         const SizedBox(height: 12),

//         // BOTTOM: SCROLLABLE EXAM LIST 
//         Expanded(
//           flex: 5,
//           child: isLoadingExams
//               ? const Center(child: CircularProgressIndicator())
//               : exams.isEmpty
//                   ? const Center(
//                       child: Text(
//                         "No exams yet",
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     )
//                   : ListView.builder(
//                       padding: EdgeInsets.zero,
//                       itemCount: exams.length,
//                       itemBuilder: (_, i) => _buildExamCard(exams[i]),
//                     ),
//         ),
//       ],
//     ),
//   );
// }


//   //  EXAM CARD UI 

// Widget _buildExamCard(ExamModel exam) {
//   final isDark = Theme.of(context).brightness == Brightness.dark;

//   Color statusColor = Colors.orange;
//   if (exam.status.toLowerCase() == "completed") statusColor = Colors.green;

//   return Container(
//     margin: const EdgeInsets.only(bottom: 12),
//     padding: const EdgeInsets.all(14),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(12),
//       color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           exam.examTitle,
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),

//         const SizedBox(height: 4),

//         Text(
//           exam.description,
//           style: TextStyle(
//             color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
//           ),
//         ),

//         const SizedBox(height: 8),

//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "Date: ${exam.examDate}",
//               style: TextStyle(color: Colors.grey.shade500),
//             ),
//             Container(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//               decoration: BoxDecoration(
//                 color: statusColor.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 exam.status,
//                 style: TextStyle(
//                   color: statusColor,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }


//   // Placeholder pages 
//   final List<Widget> _pages = [
//     const Center(child: Text("Dashboard Page")),
//     const Center(child: Text("Add Schedule")),
//     ClassScreen(),
//   ];
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedsync_app/home/edit_exam.dart';
import 'package:schedsync_app/service/exam_service.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:schedsync_app/Profile/profile_screen.dart';
import 'package:schedsync_app/class/class_screen.dart';
import 'package:schedsync_app/home/add_tab.dart';
import 'package:schedsync_app/model/base_app_user.dart';
import 'package:schedsync_app/model/exam_model.dart';

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

  List<ExamModel> exams = [];
  bool isLoadingExams = true;

  @override
  void initState() {
    super.initState();
    _loadExams();
  }

  Future<void> _loadExams() async {
    final service = ExamService();
    final data = await service.getExams(widget.currentUser.userId, context);

    setState(() {
      exams = data.map((json) => ExamModel.fromJson(json)).toList();
      isLoadingExams = false;
    });
  }

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
            const Text(' SchedSync'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: widget.switchTheme,
            icon: const Icon(Icons.brightness_6),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfilePage(
                    widget.switchTheme,
                    currentUser: widget.currentUser,
                    logout: widget.logout,
                    goToHome: () {},
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
            await showAddTabDialog(context, widget.currentUser);
            return;
          }
          setState(() => _selectedIndex = i);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), label: 'Classes'),
        ],
      ),
    );
  }

  // NEW IMPROVED HOME PAGE UI 

Widget _buildHomeContent() {
  final textColor = Theme.of(context).colorScheme.onBackground;

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TODAY HEADER
        Text(
          'TODAY',
          style: const TextStyle(
            color: Colors.lightGreen,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          DateFormat('dd MMMM, yyyy').format(DateTime.now()),
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: textColor,
              ),
        ),

        const SizedBox(height: 10),

        // COUNTERS
        Text(
          "${exams.length} Exams",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: textColor,
                fontSize: 18,
              ),
        ),

        const SizedBox(height: 12),

        // TOP: CALENDAR 
        Expanded(
          flex: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SfCalendar(
              view: CalendarView.week,
              todayHighlightColor: Theme.of(context).colorScheme.primary,
              showCurrentTimeIndicator: true,
              headerHeight: 0,
              timeSlotViewSettings: const TimeSlotViewSettings(
                startHour: 6,
                endHour: 22,
                timeIntervalHeight: 65,
                timeFormat: 'h:mm a',
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // BOTTOM: SCROLLABLE EXAM LIST 
        Expanded(
          flex: 5,
          child: isLoadingExams
              ? const Center(child: CircularProgressIndicator())
              : exams.isEmpty
                  ? const Center(
                      child: Text(
                        "No exams yet",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: exams.length,
                      itemBuilder: (_, i) => _buildExamCard(exams[i]),
                    ),
        ),
      ],
    ),
  );
}


  //  EXAM CARD UI 

Widget _buildExamCard(ExamModel exam) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  Color statusColor = Colors.orange;
  if (exam.status.toLowerCase() == "completed") statusColor = Colors.green;

  // Parse combined date-time
  final examDT = DateTime.tryParse(exam.examDatetime ?? "");
  final formattedDT = examDT != null
      ? DateFormat("MMM dd, yyyy • h:mm a").format(examDT)
      : "Unknown";

  return InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: () async {
      final updated = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditExamPage(
            exam: exam,
            currentUser: widget.currentUser,
          ),
        ),
      );

      if (updated == true) {
        _loadExams();
      }
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE
          Text(
            exam.examTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),

          // DESCRIPTION
          Text(
            exam.description,
            style: TextStyle(
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 8),

          // EXAM DATE & TIME
          Text(
            "Date & Time: $formattedDT",
            style: TextStyle(
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade600,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 10),

          // STATUS BADGE
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  exam.status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}





  // Placeholder pages 
  final List<Widget> _pages = [
    Center(child: Text("Dashboard Page")),
    Center(child: Text("Add Schedule")),
    //const ClassScreen(),
  ];
}
