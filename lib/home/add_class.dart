
import 'package:flutter/material.dart';
import 'package:schedsync_app/model/base_app_user.dart';
import 'package:schedsync_app/service/class_service.dart';
// Import ClassModel and ClassService defined above

final _classService = ClassService();

Future showAddClassSheet(
  BuildContext context, {
  // Required named parameter for connection, based on the need for user_id [5]
  required BaseAppUser currentUser,

  bool isEdit = false,
  String? classCode,
  String? className,
  TimeOfDay? timeStart,
  TimeOfDay? timeEnd,
  List? selectedDays,
  String? professor,
  String? location,
}) async {
  // Controllers
  final classNameController = TextEditingController(text: className ?? "");
  final professorController = TextEditingController(text: professor ?? "");
  final locationController = TextEditingController(text: location ?? "");

  // Class Code needs a mutable controller when adding (isEdit=false)
  final classCodeController = TextEditingController(text: classCode ?? "");

  // Time and Days initialization [14, 15]
  TimeOfDay startTime = timeStart ?? TimeOfDay(hour: 9, minute: 0);
  TimeOfDay endTime = timeEnd ?? TimeOfDay(hour: 10, minute: 0);
  List days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  List selected = selectedDays ?? [];

  final timeStartController = TextEditingController(
    text: startTime.format(context),
  );
  final timeEndController = TextEditingController(
    text: endTime.format(context),
  );

  // Time Picker Functions (modified to use StateSetter)
  Future pickStartTime(StateSetter setState) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: startTime,
    );
    if (picked != null) {
      setState(() {
        startTime = picked;
        // CRITICAL FIX: Update the controller's text to display the selected time
        timeStartController.text = startTime.format(context);
      });
    }
  }

  Future pickEndTime(StateSetter setState) async {
    final picked = await showTimePicker(context: context, initialTime: endTime);
    if (picked != null) {
      setState(() {
        endTime = picked;
        // CRITICAL FIX: Update the controller's text to display the selected time
        timeEndController.text = endTime.format(context);
      });
    }
  }

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(/* ... */),
    builder: (ctx) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
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
                  // ... (Handle UI)

                  // CLASS CODE Input [17]
                  TextField(
                    controller:
                        classCodeController, // Using persistent controller
                    readOnly: isEdit,
                    decoration: InputDecoration(
                      labelText: "Class Code *",
                      hintText: "e.g. MATH101",
                      filled: isEdit,
                      fillColor: isEdit ? Colors.grey.shade200 : null,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // CLASS NAME Input [18]
                  TextField(
                    controller: classNameController,
                    decoration: const InputDecoration(
                      labelText: "Class Name *",
                    ),
                  ),
                  const SizedBox(height: 12),

                  // DAYS OF WEEK PICKER [18]
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

                  // TIME START / END PICKERS [19]
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async => await pickStartTime(setState),
                          child: AbsorbPointer(
                            child: TextField(
                              // CORRECTION: Use the controller to display the time
                              controller: timeStartController,
                              readOnly: true, // Prevents keyboard input
                              decoration: const InputDecoration(
                                labelText: "Time Start *",
                                // Remove hintText as controller handles display
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: GestureDetector(
                          onTap: () async => await pickEndTime(setState),
                          child: AbsorbPointer(
                            child: TextField(
                              // CORRECTION: Use the controller to display the time
                              controller: timeEndController,
                              readOnly: true, // Prevents keyboard input
                              decoration: const InputDecoration(
                                labelText: "Time End *",
                                // Remove hintText as controller handles display
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // PROFESSOR [20]
                  TextField(
                    controller: professorController,
                    decoration: const InputDecoration(
                      labelText: "Professor (optional)",
                    ),
                  ),
                  const SizedBox(height: 12),

                  // LOCATION [20]
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      labelText: "Location (optional)",
                    ),
                  ),

                  const SizedBox(height: 20),

                  // SAVE BUTTON [21]
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Validation based on Lambda requirements [6]
                        if (classNameController.text.isEmpty ||
                            classCodeController
                                .text
                                .isEmpty || // Required by Lambda & PK [6]
                            selected.isEmpty) {
                          // Required by Lambda [6]
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Class Code, Class Name, and Days are required.",
                              ),
                            ),
                          );
                          return;
                        }

                        // Time formatting and validation
                        final timeStartStr = startTime.format(context);
                        final timeEndStr = endTime.format(context);

                        if (timeStartStr.isEmpty || timeEndStr.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Time Start and Time End are required.",
                              ),
                            ),
                          );
                          return;
                        }

                        // Call Service
                        final createdClass = await _classService.addClass(
                          context: context,
                          userId: currentUser.userId,
                          classCode: classCodeController.text.trim(),
                          className: classNameController.text.trim(),
                          timeStart: timeStartStr,
                          timeEnd: timeEndStr,
                          daysOfWeek: List<String>.from(selected),
                          professor: professorController.text.trim().isEmpty
                              ? null
                              : professorController.text.trim(),
                          location: locationController.text.trim().isEmpty
                              ? null
                              : locationController.text.trim(),
                        );

                        if (createdClass != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Class added successfully.'),
                            ),
                          );
                          Navigator.pop(ctx, createdClass); // Close sheet [21]
                        }
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
