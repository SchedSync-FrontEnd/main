class ExamModel {
  final String examId;
  final String userId;
  final String classId;   // REQUIRED
  final String examTitle;
  final String description;
  final String examDate;
  final String deadline;
  final String status;

  ExamModel({
    required this.examId,
    required this.userId,
    required this.classId,     // REQUIRED
    required this.examTitle,
    required this.description,
    required this.examDate,
    required this.deadline,
    required this.status,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      examId: json['exam_id'] ?? '',
      userId: json['user_id'] ?? '',
      classId: json['class_id'] ?? '',   // REQUIRED
      examTitle: json['exam_title'] ?? '',
      description: json['description'] ?? '',
      examDate: json['exam_date'] ?? '',
      deadline: json['deadline'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exam_id': examId,
      'user_id': userId,
      'class_id': classId,  // REQUIRED
      'exam_title': examTitle,
      'description': description,
      'exam_date': examDate,
      'deadline': deadline,
      'status': status,
    };
  }
}
