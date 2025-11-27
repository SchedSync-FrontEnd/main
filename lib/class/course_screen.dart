import 'package:flutter/material.dart';
import 'package:schedsync_app/model/class_model.dart';
import 'package:schedsync_app/model/exam_model.dart';
import 'package:schedsync_app/model/submission_model.dart';

// TEMP dummy exams/submissions — replace with real API later
final List<ExamModel> dummyExams = [];
final List<SubmissionModel> dummySubmissions = [];

class TaskItem extends StatefulWidget {
  final String date;
  final String title;

  const TaskItem({
    super.key,
    required this.date,
    required this.title,
  });

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (v) {
              setState(() => isChecked = v ?? false);
            },
          ),
          Text(widget.date, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Expanded(child: Text(widget.title)),
          PopupMenuButton(
            itemBuilder: (context) => const [
              PopupMenuItem(value: "edit", child: Text("Edit")),
              PopupMenuItem(value: "delete", child: Text("Delete")),
            ],
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
    );
  }
}

class CourseScreen extends StatelessWidget {
  final ClassModel classItem;

  const CourseScreen({super.key, required this.classItem});

  @override
  Widget build(BuildContext context) {
    final exams = dummyExams.where((e) => e.classId == classItem.classCode).toList();
    final submissions = dummySubmissions.where((s) => s.classId == classItem.classCode).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(classItem.className),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              // delete class logic here
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //-------------------------------
            // CLASS HEADER CARD
            //-------------------------------
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left Column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              classItem.className,
                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),

                            // TIME + DAYS
                            Text(
                              "${classItem.timeStart} - ${classItem.timeEnd}",
                              style: const TextStyle(color: Colors.grey),
                            ),

                            Text(
                              classItem.daysOfWeek.join(", "),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),

                        PopupMenuButton(
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: "edit", child: Text("Edit")),
                          ],
                        )
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Professor info line
                    Row(
                      children: [
                        const Icon(Icons.person_outline, color: Colors.blue, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          classItem.professor ?? "",
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        )
                      ],
                    )

                  ],
                ),
              ),
            ),

            const SizedBox(height: 26),

            //-----------------------------------------
            // COURSE CODE
            //-----------------------------------------
            const Text("COURSE CODE",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(classItem.classCode, style: Theme.of(context).textTheme.titleLarge),
            const Divider(height: 30),

            //-----------------------------------------
            // LOCATION
            //-----------------------------------------
            const Text("LOCATION",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(classItem.location ?? "", style: Theme.of(context).textTheme.titleLarge),
            const Divider(height: 30),

            //-----------------------------------------
            // EXAMS
            //-----------------------------------------
            const Text("EXAMS",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),

            if (exams.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text("No exams yet.", style: TextStyle(color: Colors.grey)),
              )
            else
              ...exams.map((e) => TaskItem(date: e.examDatetime, title: e.examTitle)),

            const Divider(height: 30),

            //-----------------------------------------
            // SUBMISSIONS
            //-----------------------------------------
            const Text("SUBMISSIONS",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),

            if (submissions.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text("No submissions yet.", style: TextStyle(color: Colors.grey)),
              )
            else
              ...submissions.map((s) => TaskItem(date: s.submissionDate, title: s.title)),
          ],
        ),
      ),
    );
  }
}
