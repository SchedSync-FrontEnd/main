class ExamModel {
  // Fields based on the 'Exams' table in the ERD [1, 2]
  final String examId;        // exam_id (varchar) [1, 2]
  final String userId;        // user_id (varchar) [1, 2]
  final String classId;       // FK linking back to Classes table
  final String examTitle;     // exam_title (varchar) [1, 2]
  final String description;   // description (text) [1, 2]
  final String examDate;      // exam_date (datetime) [1, 2]
  final String deadline;      // deadline (datetime) [1, 2]
  final String status;        // status (varchar) [1, 2]

  ExamModel({
    required this.examId,
    required this.userId,
    required this.classId, 
    required this.examTitle,
    required this.description,
    required this.examDate,
    required this.deadline,
    required this.status,
  });

  // Factory constructor for creating an instance from a JSON map
  factory ExamModel.fromJson(Map json) {
    return ExamModel(
      examId: json['exam_id'] as String,
      userId: json['user_id'] as String,
      classId: json['class_id'] as String,
      examTitle: json['exam_title'] as String,
      description: json['description'] as String,
      examDate: json['exam_date'] as String,
      deadline: json['deadline'] as String,
      status: json['status'] as String,
    );
  }

  // Method to convert the model back to JSON
  Map toJson() {
    return {
      'exam_id': examId,
      'user_id': userId,
      'exam_title': examTitle,
      'description': description,
      'exam_date': examDate,
      'deadline': deadline,
      'status': status,
    };
  }
}