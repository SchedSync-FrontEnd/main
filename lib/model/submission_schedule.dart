import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class Submission {
  final String uuid;

  // required
  final String title;
  final String submissionDate; 
  final String deadline;       

  // optional
  final String? description;
  final String? status;        

  final String createdDate;

  // MAIN CONSTRUCTOR (for NEW submissions) 
  Submission({
    required this.title,
    required this.submissionDate,
    required this.deadline,
    this.description,
    this.status,
  })  : uuid = _uuid.v4(),
        createdDate = DateTime.now().toIso8601String();

  // FROM EXISTING DATA 
  Submission.fromData({
    required this.uuid,
    required this.title,
    required this.submissionDate,
    required this.deadline,
    required this.createdDate,
    this.description,
    this.status,
  });

 
  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission.fromData(
      uuid: json['uuid'] ?? _uuid.v4(),
      title: json['title'] ?? '',
      submissionDate: json['submissionDate'] ?? '',
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
      'title': title,
      'submissionDate': submissionDate,
      'deadline': deadline,
      'description': description,
      'status': status,
      'createdDate': createdDate,
    };
  }
}
