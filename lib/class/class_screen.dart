// import 'package:flutter/material.dart';
// import 'package:schedsync_app/class/course_screen.dart';
// import 'package:schedsync_app/model/class_model.dart';

// // --- Dummy Data List using the ClassModel ---
// final List<ClassModel> dummyClasses = [
//   ClassModel(
//     classId: 'c1',
//     userId: 'u1',
//     className: 'Physics',
//     classCode: 'P101',
//     daysOfWeek: ['Monday', 'Thursday'],
//     timeStart: '9:30 am',
//     timeEnd: '10:30 am',
//     professor: 'Dr. Smith',
//     location: 'Rm 101',
//   ),
//   ClassModel(
//    classId: 'c2',
//     userId: 'u1',
//     className: 'History',
//     classCode: 'H202',
//     daysOfWeek: ['Monday', 'Thursday'],
//     timeStart: '1:00 pm',
//     timeEnd: '2:00 pm',
//     professor: 'Prof. Jones',
//     location: 'Auditorium A',
//   ),
//   ClassModel(
//     classId: 'c3',
//     userId: 'u1',
//     className: 'Chemistry',
//     classCode: 'C303',
//     daysOfWeek: ['Monday'],
//     timeStart: '2:00 pm',
//     timeEnd: '3:00 pm',
//     professor: 'Dr. Lee',
//     location: 'Lab 2',
//   ),
//   ClassModel(
//     classId: 'c4',
//     userId: 'u1',
//     className: 'Biology',
//     classCode: 'B404',
//     daysOfWeek: ['Tuesday', 'Friday', 'Saturday'],
//     timeStart: '1:00 pm',
//     timeEnd: '3:00 pm',
//     professor: 'Prof. Green',
//     location: 'Rm 305',
//   ),
//   ClassModel(
//     classId: 'c5',
//     userId: 'u1',
//     className: 'Economics',
//     classCode: 'E505',
//     daysOfWeek: ['Tuesday', 'Friday'],
//     timeStart: '4:00 pm',
//     timeEnd: '5:00 pm',
//     professor: 'Dr. White',
//     location: 'Online',
//   ),
// ];

// // --- Custom Widget for the individual class card design
// class ClassCard extends StatelessWidget {
//   const ClassCard({
//     required this.classItem,
//     super.key,
//   });

//   final ClassModel classItem;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 1.5,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       child: InkWell(
//         onTap: () {
//           // Navigate to CourseScreen, passing the specific class data
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (ctx) => CourseScreen(classItem: classItem),
//             ),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     // Uses className from the model
//                     classItem.className,
//                     style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     // Uses the formatted schedule getter from the model
//                     classItem.schedule,
//                     style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//               const Icon(Icons.chevron_right),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // --- Main Class Screen Implementation ---
// class ClassScreen extends StatelessWidget {
//   const ClassScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // AppBar structure matching the image [3, 4]
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: (){},
//         ),
//         centerTitle: true,
//         title: const Text('My Classes'),
//       ),
      
//       // Body containing the list of classes
//       body: ListView.builder(
//         itemCount: dummyClasses.length,
//         itemBuilder: (context, index) {
//           // Passes the model instance to the card widget
//           return ClassCard(classItem: dummyClasses[index]);
//         },
//       ),
     
//     );
//   }
// }