import 'package:uuid/uuid.dart'; 

class ClassModel {
 
  final String classId;        
  final String userId;         
  final String className;      
  final String classCode;      
  final List<String> daysOfWeek; 
  final String timeStart;      
  final String timeEnd;        
  final String professor;      
  final String location;       

  ClassModel({
    required this.classId,
    required this.userId,
    required this.className,
    required this.classCode,
    required this.daysOfWeek,
    required this.timeStart,
    required this.timeEnd,
    required this.professor,
    required this.location,
  });

  String get schedule {
    final days = daysOfWeek.join(' | ');
    return '$days\n$timeStart - $timeEnd';
  }

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      classId: json['class_id'] as String,
      userId: json['user_id'] as String,
      className: json['class_name'] as String,
      classCode: json['class_code'] as String,
      daysOfWeek: List<String>.from(json['days_of_week'] as List), 
      timeStart: json['time_start'] as String,
      timeEnd: json['time_end'] as String,
      professor: json['professor'] as String,
      location: json['location'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class_id': classId,
      'user_id': userId,
      'class_name': className,
      'class_code': classCode,
      'days_of_week': daysOfWeek,
      'time_start': timeStart,
      'time_end': timeEnd,
      'professor': professor,
      'location': location,
    };
  }
}
