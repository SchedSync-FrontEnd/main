import 'package:flutter/material.dart';
import 'package:schedsync_app/model/base_app_user.dart';

Future<void> showAddClassSheet({
  required BuildContext context,
  required BaseAppUser currentUser,
  bool isEdit = false,
  String? classCode,
  String? className,
  TimeOfDay? timeStart,
  TimeOfDay? timeEnd,
  List<String>? selectedDays,
  String? professor,
  String? location,
}) async {
  final classNameController = TextEditingController(text: className ?? "");
  final professorController = TextEditingController(text: professor ?? "");
  final locationController = TextEditingController(text: location ?? "");

  TimeOfDay startTime = timeStart ?? const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay endTime = timeEnd ?? const TimeOfDay(hour: 10, minute: 0);

  // NEW CONTROLLERS FOR TIME DISPLAY
  final startTimeController = TextEditingController(
    text: startTime.format(context),
  );

  final endTimeController = TextEditingController(
    text: endTime.format(context),
  );

  List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  List<String> selected = selectedDays ?? [];

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // GRAB HANDLE
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  // CLASS CODE
                  TextField(
                    controller: TextEditingController(text: classCode ?? ""),
                    readOnly: isEdit,
                    decoration: InputDecoration(
                      labelText: "Class Code *",
                      hintText: "e.g. MATH101",
                      filled: isEdit,
                      fillColor: isEdit ? Colors.grey.shade200 : null,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // CLASS NAME
                  TextField(
                    controller: classNameController,
                    decoration: const InputDecoration(
                      labelText: "Class Name *",
                    ),
                  ),
                  const SizedBox(height: 12),

                  // DAYS
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Days of Week *",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,
                    children: days.map((d) {
                      final isSelected = selected.contains(d);
                      return ChoiceChip(
                        label: Text(d),
                        selected: isSelected,
                        onSelected: (val) {
                          setState(() {
                            if (val) {
                              selected.add(d);
                            } else {
                              selected.remove(d);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // FIXED TIME SECTION
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: startTime,
                            );
                            if (picked != null) {
                              setState(() {
                                startTime = picked;
                                startTimeController.text = picked.format(
                                  context,
                                );
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: TextField(
                              controller: startTimeController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: "Time Start *",
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: endTime,
                            );

                            if (picked != null) {
                              final startInMinutes =
                                  startTime.hour * 60 + startTime.minute;
                              final endInMinutes =
                                  picked.hour * 60 + picked.minute;

                              if (endInMinutes <= startInMinutes) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "End time must be AFTER start time.",
                                    ),
                                  ),
                                );
                                return;
                              }

                              setState(() {
                                endTime = picked;
                                endTimeController.text = picked.format(context);
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: TextField(
                              controller: endTimeController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: "Time End *",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // PROFESSOR
                  TextField(
                    controller: professorController,
                    decoration: const InputDecoration(
                      labelText: "Professor (optional)",
                    ),
                  ),
                  const SizedBox(height: 12),

                  // LOCATION
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      labelText: "Location (optional)",
                    ),
                  ),
                  const SizedBox(height: 20),

                  // SAVE BUTTON
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        if (classNameController.text.isEmpty ||
                            selected.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please fill in all required fields.",
                              ),
                            ),
                          );
                          return;
                        }

                        Navigator.pop(ctx);
                      },
                      child: const Text("Save"),
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
