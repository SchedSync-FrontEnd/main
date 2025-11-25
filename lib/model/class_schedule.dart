import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class ClassSchedule {
  final String uuid;

  // required fields
  final String classCode;
  final String className;
  final String timeStart;   
  final String timeEnd;     
  final List<String> daysOfWeek;

  // optional 
  final String? professor;
  final String? location;

  final String createdDate;

  //  MAIN CONSTRUCTOR (for NEW classes) 
  ClassSchedule({
    required this.classCode,
    required this.className,
    required this.timeStart,
    required this.timeEnd,
    required this.daysOfWeek,
    this.professor,
    this.location,
  })  : uuid = _uuid.v4(),
        createdDate = DateTime.now().toIso8601String();

  // FROM EXISTING DATA 
  ClassSchedule.fromData({
    required this.uuid,
    required this.classCode,
    required this.className,
    required this.timeStart,
    required this.timeEnd,
    required this.daysOfWeek,
    required this.createdDate,
    this.professor,
    this.location,
  });

  factory ClassSchedule.fromJson(Map<String, dynamic> json) {
    return ClassSchedule.fromData(
      uuid: json['uuid'] ?? _uuid.v4(),
      classCode: json['classCode'] ?? '',
      className: json['className'] ?? '',
      timeStart: json['timeStart'] ?? '',
      timeEnd: json['timeEnd'] ?? '',
      daysOfWeek: List<String>.from(json['daysOfWeek'] ?? []),
      createdDate: json['createdDate'] ??
          DateTime.now().toIso8601String(),
      professor: json['professor'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'classCode': classCode,
      'className': className,
      'timeStart': timeStart,
      'timeEnd': timeEnd,
      'daysOfWeek': daysOfWeek,
      'professor': professor,
      'location': location,
      'createdDate': createdDate,
    };
  }
}
