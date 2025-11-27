class ExamModel {
  final String examId;
  final String userId;
  final String classId;
  final String examTitle;
  final String description;

  /// Unified date + time field
  final String examDatetime;

  final String status;

  ExamModel({
    required this.examId,
    required this.userId,
    required this.classId,
    required this.examTitle,
    required this.description,
    required this.examDatetime,
    required this.status,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      examId: json['exam_id'] ?? '',
      userId: json['user_id'] ?? '',
      classId: json['class_id'] ?? '',
      examTitle: json['exam_title'] ?? '',
      description: json['description'] ?? '',

      /// Supports both new & old fields for safety  
      examDatetime: json['exam_datetime']
          ?? json['deadline']     // fallback (old data)
          ?? json['exam_date']    // fallback (old data)
          ?? '',

      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exam_id': examId,
      'user_id': userId,
      'class_id': classId,
      'exam_title': examTitle,
      'description': description,
      'exam_datetime': examDatetime,
      'status': status,
    };
  }
}
