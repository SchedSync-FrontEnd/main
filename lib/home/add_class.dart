import 'package:flutter/material.dart';

Future<void> showAddClassSheet(
  BuildContext context, {
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

  TimeOfDay startTime = timeStart ?? TimeOfDay(hour: 9, minute: 0);
  TimeOfDay endTime = timeEnd ?? TimeOfDay(hour: 10, minute: 0);

  List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  List<String> selected = selectedDays ?? [];

  Future<void> pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: startTime,
    );
    if (picked != null) {
      startTime = picked;
    }
  }

  Future<void> pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: endTime,
    );
    if (picked != null) {
      endTime = picked;
    }
  }

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
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
            
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),

              // CLASS CODE (NOT EDITABLE WHEN EDITING)
              TextField(
                controller: TextEditingController(text: classCode ?? ""),
                readOnly: isEdit, // prevents editing
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

              // DAYS OF WEEK
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
                      if (val) {
                        selected.add(d);
                      } else {
                        selected.remove(d);
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              //  TIME START / END 
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: pickStartTime,
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: "Time Start *",
                            hintText: startTime.format(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: pickEndTime,
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: "Time End *",
                            hintText: endTime.format(context),
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
                          content: Text("Please fill in all required fields."),
                        ),
                      );
                      return;
                    }

                    Navigator.pop(ctx); // Close bottom sheet

                    // TODO: return data to HomeScreen or save to DB
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
}
