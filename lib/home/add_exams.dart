import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> showAddExamSheet(BuildContext context) async {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedDeadline;

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      selectedDate = picked;
    }
  }

  Future<void> pickDeadline() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 9, minute: 00),
    );
    if (picked != null) {
      selectedDeadline = picked;
    }
  }

  String status = "pending"; // default status

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
          top: 8,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // drag handle
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

              // Title (required) 
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
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                ),
              ),
              const SizedBox(height: 12),

              // Exam Date (required)
              GestureDetector(
                onTap: pickDate,
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Exam Date *',
                      hintText: selectedDate == null
                          ? 'Choose date'
                          : DateFormat('yyyy-MM-dd').format(selectedDate!),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Deadline Time (required)
              GestureDetector(
                onTap: pickDeadline,
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Deadline Time *',
                      hintText: selectedDeadline == null
                          ? 'Choose time'
                          : selectedDeadline!.format(context),
                      suffixIcon: const Icon(Icons.access_time),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Status (optional)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Mark as done"),
                  Switch(
                    value: status == "done",
                    onChanged: (val) {
                      status = val ? "done" : "pending";
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
                    if (titleController.text.isEmpty ||
                        selectedDate == null ||
                        selectedDeadline == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please complete all required fields."),
                        ),
                      );
                      return;
                    }

                    // TODO: save exam model here
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
}
