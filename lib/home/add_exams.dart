import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedsync_app/service/exam_service.dart';
import 'package:schedsync_app/model/base_app_user.dart';

Future<void> showAddExamSheet(
  BuildContext context,
  BaseAppUser currentUser,
) async {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final examService = ExamService();

  DateTime? selectedDate;
  TimeOfDay? selectedDeadline;

  final dateController = TextEditingController();
  final timeController = TextEditingController();

  String status = "pending";

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          Future<void> pickDate() async {
            final now = DateTime.now();

            final picked = await showDatePicker(
              context: ctx,
              initialDate: now,
              firstDate: DateTime(now.year, now.month, now.day),
              lastDate: DateTime(2100),
            );

            if (picked != null) {
              setState(() {
                selectedDate = picked;
                dateController.text = DateFormat('yyyy-MM-dd').format(picked);
              });
            }
          }

          Future<void> pickDeadline() async {
            final picked = await showTimePicker(
              context: ctx,
              initialTime: const TimeOfDay(hour: 9, minute: 0),
            );

            if (picked != null) {
              setState(() {
                selectedDeadline = picked;
                timeController.text = picked.format(ctx);
              });
            }
          }

          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Title
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Exam Title *',
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Description
                  TextField(
                    controller: descriptionController,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),

                  const SizedBox(height: 12),

                  // Exam Date
                  GestureDetector(
                    onTap: pickDate,
                    child: AbsorbPointer(
                      child: TextField(
                        controller: dateController,
                        decoration: const InputDecoration(
                          labelText: 'Exam Date *',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Deadline time
                  GestureDetector(
                    onTap: pickDeadline,
                    child: AbsorbPointer(
                      child: TextField(
                        controller: timeController,
                        decoration: const InputDecoration(
                          labelText: 'Deadline Time *',
                          suffixIcon: Icon(Icons.access_time),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // SAVE BUTTON
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (titleController.text.isEmpty ||
                            dateController.text.isEmpty ||
                            timeController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please complete all required fields.",
                              ),
                            ),
                          );
                          return;
                        }

                        final examDate = DateFormat(
                          'yyyy-MM-dd',
                        ).format(selectedDate!);

                        final deadline =
                            DateFormat('yyyy-MM-dd').format(selectedDate!) +
                            "T" +
                            selectedDeadline!.hour.toString().padLeft(2, '0') +
                            ":" +
                            selectedDeadline!.minute.toString().padLeft(2, '0');

                        final success = await examService.addExam(
                          context: context,
                          userId: currentUser.userId,
                          title: titleController.text.trim(),
                          description: descriptionController.text.trim(),
                          examDate: examDate,
                          deadline: deadline,
                        );

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Exam added successfully!"),
                            ),
                          );
                          Navigator.pop(ctx);
                        }
                      },

                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
