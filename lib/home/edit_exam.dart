import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedsync_app/model/base_app_user.dart';
import 'package:schedsync_app/model/exam_model.dart';
import 'package:schedsync_app/service/exam_service.dart';

class EditExamPage extends StatefulWidget {
  final ExamModel exam;
  final BaseAppUser currentUser;

  const EditExamPage({
    super.key,
    required this.exam,
    required this.currentUser,
  });

  @override
  State<EditExamPage> createState() => _EditExamPageState();
}

class _EditExamPageState extends State<EditExamPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController descriptionController;
  late TextEditingController classIdController;

  late DateTime selectedDateTime;
  String status = "pending";

  @override
  void initState() {
    super.initState();

    descriptionController = TextEditingController(text: widget.exam.description);
    classIdController = TextEditingController(text: widget.exam.classId);

    // Parse unified datetime
    selectedDateTime = DateTime.tryParse(widget.exam.examDatetime) ?? DateTime.now();
    status = widget.exam.status;
  }

  Future<void> pickDateTime() async {
    // Pick Date
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    // Pick Time
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
    );

    if (pickedTime == null) return;

    setState(() {
      selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = widget.currentUser.userId;

    Map<String, dynamic> updateBody = {
      "exam_id": widget.exam.examId,
    };

    if (classIdController.text.trim() != widget.exam.classId) {
      updateBody["class_id"] = classIdController.text.trim();
    }

    if (descriptionController.text.trim() != widget.exam.description) {
      updateBody["description"] = descriptionController.text.trim();
    }

    // 🔥 Unified date+time update
    String newDateTime = DateFormat("yyyy-MM-ddTHH:mm").format(selectedDateTime);

    if (newDateTime != widget.exam.examDatetime) {
      updateBody["exam_datetime"] = newDateTime;
    }

    if (status != widget.exam.status) {
      updateBody["status"] = status;
    }

    if (updateBody.length == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nothing to update")),
      );
      return;
    }

    final success = await ExamService().updateExam(
      userId: userId,
      updateBody: updateBody,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Update failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat("MMMM dd, yyyy").format(selectedDateTime);
    final timeFormatted = DateFormat("h:mm a").format(selectedDateTime);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Exam")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // DESCRIPTION
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),

              // CLASS ID
              TextFormField(
                controller: classIdController,
                decoration: const InputDecoration(labelText: "Class ID"),
              ),

              const SizedBox(height: 20),

              // DATE + TIME DISPLAY
              Text(
                "Exam Date & Time",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateFormatted,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          timeFormatted,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: pickDateTime,
                      icon: const Icon(Icons.edit_calendar, size: 28),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // STATUS DROPDOWN
              DropdownButtonFormField(
                value: status,
                items: ["pending", "completed"]
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => status = v!,
                decoration: const InputDecoration(labelText: "Status"),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: saveChanges,
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
