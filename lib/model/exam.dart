import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class Exam {
  final String uuid;

  // required
  final String examTitle;
  final String examDate;   
  final String deadline;   

  // optional
  final String? description;
  final String? status;    

  final String createdDate;

  //  MAIN CONSTRUCTOR (for NEW exams) -
  Exam({
    required this.examTitle,
    required this.examDate,
    required this.deadline,
    this.description,
    this.status,
  })  : uuid = _uuid.v4(),
        createdDate = DateTime.now().toIso8601String();

  // FROM EXISTING DATA 
  Exam.fromData({
    required this.uuid,
    required this.examTitle,
    required this.examDate,
    required this.deadline,
    required this.createdDate,
    this.description,
    this.status,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam.fromData(
      uuid: json['uuid'] ?? _uuid.v4(),
      examTitle: json['examTitle'] ?? '',
      examDate: json['examDate'] ?? '',
      deadline: json['deadline'] ?? '',
      description: json['description'],
      status: json['status'],
      createdDate: json['createdDate'] ??
          DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'examTitle': examTitle,
      'examDate': examDate,
      'deadline': deadline,
      'description': description,
      'status': status,
      'createdDate': createdDate,
    };
  }
}
