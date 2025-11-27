class ClassModel {
  final String classCode; // PK
  final String userId;    // SK
  final String className;
  final String timeStart;
  final String timeEnd;
  final List<String> daysOfWeek;
  final String? professor;
  final String? location;

  ClassModel({
    required this.classCode,
    required this.userId,
    required this.className,
    required this.timeStart,
    required this.timeEnd,
    required this.daysOfWeek,
    this.professor,
    this.location,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      classCode: json['class_code'] ?? '',
      userId: json['user_id'] ?? '',
      className: json['class_name'] ?? '',
      timeStart: json['time_start'] ?? '',
      timeEnd: json['time_end'] ?? '',
      daysOfWeek: List<String>.from(json['days_of_week'] ?? []),
      professor: json['professor'],
      location: json['location'],
    );
  }
}

