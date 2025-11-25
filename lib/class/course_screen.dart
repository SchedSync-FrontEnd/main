import 'package:flutter/material.dart';
import 'package:schedsync_app/model/class_model.dart'; 
import 'package:schedsync_app/model/exam_model.dart'; 
import 'package:schedsync_app/model/submission_model.dart'; 

// --- DUMMY DATA ---
// A sample ClassModel definition for testing, matching the structure required
// Note: In a real app, this data would come from the API via the ClassScreen.
final ClassModel sampleClass = ClassModel(
  classId: 'c1', userId: 'u1', className: 'Physics', classCode: 'APM1104',
  daysOfWeek: ['Monday', 'Thursday'], timeStart: '9:30 am', timeEnd: '10:30 am',
  professor: 'Mr. Paul Delos Santos', location: 'ADB 305',
);

final List<ExamModel> dummyExams = [
  ExamModel(
    examId: 'e1', userId: 'u1', classId: 'c2', 
    examTitle: 'Midterm Exam', description: 'Covers Chapters 1-5', 
    examDate: '11/15/2025', deadline: '11/15/2025', status: 'Pending',
  ),
   ExamModel(
    examId: 'e1', userId: 'u1', classId: 'c2', 
    examTitle: 'Midterm Exam', description: 'Covers Chapters 1-5', 
    examDate: '11/15/2025', deadline: '11/15/2025', status: 'Pending',
  ),
];

final List<SubmissionModel> dummySubmissions = [
  SubmissionModel(
    submissionId: 's1', userId: 'u1', classId: 'c1',
    title: 'Formative Assessment #1', description: 'Kinematics', 
    submissionDate: '11/15/2025', deadline: '11/15/2025', status: 'Pending',
  ),
  SubmissionModel(
    submissionId: 's2', userId: 'u1', classId: 'c1',
    title: 'Laboratory Activity #1', description: 'Experiment 3', 
    submissionDate: '11/18/2025', deadline: '11/18/2025', status: 'Pending',
  ),
];

// --- Custom Component for Exam/Submission list item ---
class TaskItem extends StatefulWidget {
  final String date;
  final String title;
  const TaskItem({required this.date, required this.title, super.key});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool isChecked = false; // State to track completion status

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Checkbox for completion state 
          Checkbox(
            value: isChecked,
            onChanged: (bool? newValue) {
              setState(() {
                isChecked = newValue ?? false;
              });
            },
          ),
          // Date and Title display 
          Text(widget.date, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(child: Text(widget.title)),
          
          // Context menu icon shown in the design 
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle Edit/Delete actions here
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
              const PopupMenuItem<String>(value: 'delete', child: Text('Delete')),
            ],
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
    );
  }
}

// --- Main Course Screen Implementation ---
class CourseScreen extends StatelessWidget {
  final ClassModel classItem;
  
  // The screen requires the specific class data passed from ClassScreen
  const CourseScreen({required this.classItem, super.key});

  @override
  Widget build(BuildContext context) {
    
    // Filter tasks relevant to the current class
    final exams = dummyExams.where((e) => e.classId == classItem.classId).toList();
    final submissions = dummySubmissions.where((s) => s.classId == classItem.classId).toList();

    return Scaffold(
      appBar: AppBar(
        // Back arrow 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the ClassScreen (pop the current route)
            Navigator.of(context).pop(); 
          },
        ),
        centerTitle: true,
        title: Text(classItem.className), // Title based on class name 
        actions: [
          // Delete icon 
          IconButton(
            icon: const Icon(Icons.delete_outline), 
            onPressed: () {
              // Handle class deletion logic
            },
          ),
        ],
      ),
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Class Information Card (Header) ---
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                classItem.className,
                                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                // Display formatted schedule
                                classItem.schedule.replaceAll('\n', '  ',), 
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                          
                          // Edit Context Menu for the class card 
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                // Handle Edit Class action
                              }
                            },
                            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                            ],
                            icon: const Icon(Icons.more_vert),
                          ),
                        ],
                      ),
                      
                      // Professor Info 
                      Row(
                        children: [
                          const Icon(Icons.person_outline, size: 18, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            classItem.professor, 
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.blue, 
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // --- COURSE CODE Section ---
              const Text(
                'COURSE CODE',
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                classItem.classCode, 
                style: Theme.of(context).textTheme.titleLarge,
              ),
              
              const Divider(height: 30),
              
              // --- LOCATION Section ---
              const Text(
                'LOCATION',
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                classItem.location, 
                style: Theme.of(context).textTheme.titleLarge,
              ),
              
              const Divider(height: 30),
              
              // --- EXAMS Section ---
              const Text(
                'EXAM',
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              // Map exams to TaskItem widgets
              ...exams.map((exam) => TaskItem(
                date: exam.examDate, 
                title: exam.examTitle,
              )).toList(),
              
              const Divider(height: 30),

              // --- SUBMISSIONS Section ---
              const Text(
                'SUBMISSIONS',
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              // Map submissions to TaskItem widgets
              ...submissions.map((submission) => TaskItem(
                date: submission.submissionDate, 
                title: submission.title,
              )).toList(),

            ],
          ),
        ),
      ),
    );
  }
}