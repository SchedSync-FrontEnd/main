class SubmissionModel {
  // Fields based on the 'Submissions' table in the ERD [1, 2]
  final String submissionId;  // submission_id (varchar) [1, 2]
  final String userId;        // user_id (varchar) [1, 2]
  final String classId;
  final String title;         // title (varchar) [1, 2]
  final String description;   // description (text) [1, 2]
  final String submissionDate; // submission_date (date) [1, 2]
  final String deadline;      // deadline (datetime) [1, 2]
  final String status;        // status (varchar) [1, 2]

  SubmissionModel({
    required this.submissionId,
    required this.userId,
     required this.classId,
    required this.title,
    required this.description,
    required this.submissionDate,
    required this.deadline,
    required this.status,
  });

  // Factory constructor for creating an instance from a JSON map
  factory SubmissionModel.fromJson(Map json) {
    return SubmissionModel(
      submissionId: json['submission_id'] as String,
      userId: json['user_id'] as String,
      classId: json['class_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      submissionDate: json['submission_date'] as String,
      deadline: json['deadline'] as String,
      status: json['status'] as String,
    );
  }

  // Method to convert the model back to JSON
  Map toJson() {
    return {
      'submission_id': submissionId,
      'user_id': userId,
      'title': title,
      'description': description,
      'submission_date': submissionDate,
      'deadline': deadline,
      'status': status,
    };
  }
}