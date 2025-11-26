import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedsync_app/model/base_app_user.dart';

Future<void> showAddSubmissionSheet({
  required BuildContext context,
  required BaseAppUser currentUser,
}) async {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedDeadline;

  // NEW CONTROLLERS TO DISPLAY SELECTED VALUES
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  String status = "pending"; // default

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          // PICK DATE
          Future<void> pickDate() async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: ctx,
              initialDate: DateTime.now(),
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

          // PICK TIME + VALIDATION
          Future<void> pickDeadline() async {
            final picked = await showTimePicker(
              context: ctx,
              initialTime: const TimeOfDay(hour: 9, minute: 0),
            );

            if (picked != null) {
              // Convert selected time to minutes
              final pickedMinutes = picked.hour * 60 + picked.minute;

              // Get current time
              final now = DateTime.now();
              final currentMinutes = now.hour * 60 + now.minute;

              // Condition: Only validate if selected date is TODAY
              if (selectedDate != null) {
                final isToday =
                    selectedDate!.year == now.year &&
                    selectedDate!.month == now.month &&
                    selectedDate!.day == now.day;

                if (isToday && pickedMinutes <= currentMinutes) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Deadline cannot be earlier than the current time.",
                      ),
                    ),
                  );
                  return;
                }
              }

              // VALID → Update
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
                  // DRAG HANDLE
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Title
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title *'),
                  ),
                  const SizedBox(height: 12),

                  // Description
                  TextField(
                    controller: descriptionController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Description (optional)',
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Submission Date (FIXED)
                  GestureDetector(
                    onTap: pickDate,
                    child: AbsorbPointer(
                      child: TextField(
                        controller: dateController,
                        decoration: const InputDecoration(
                          labelText: 'Submission Date *',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Deadline Time (FIXED)
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
                  const SizedBox(height: 12),

                  // Status Switch
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Mark as done"),
                      Switch(
                        value: status == "done",
                        onChanged: (val) {
                          setState(() {
                            status = val ? "done" : "pending";
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // SAVE BUTTON
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        // VALIDATION
                        if (titleController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Title is required.")),
                          );
                          return;
                        }

                        if (dateController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Submission date is required."),
                            ),
                          );
                          return;
                        }

                        if (timeController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Deadline time is required."),
                            ),
                          );
                          return;
                        }

                        // TODO: Create Submission model here

                        Navigator.pop(ctx);
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
