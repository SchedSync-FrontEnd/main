import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class BaseAppUser {
  final String uuid;
  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final String createdDate;

  BaseAppUser({
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
  })  : uuid = _uuid.v4(),
        createdDate = DateTime.now().toIso8601String();

  BaseAppUser.fromData({
    required this.uuid,
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.createdDate,
  });

  factory BaseAppUser.fromJson(Map<String, dynamic> json) {
    return BaseAppUser.fromData(
      uuid: json['uuid'] ?? _uuid.v4(),
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      createdDate: json['createdDate'] ??
          DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'username': username,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'createdDate': createdDate,
    };
  }
}
