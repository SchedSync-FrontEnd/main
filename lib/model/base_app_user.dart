import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class BaseAppUser {
  final String uuid;
  final String userId;   
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String createdDate;

  BaseAppUser({
     required this.userId,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  })  : uuid = _uuid.v4(),
        createdDate = DateTime.now().toIso8601String();

  BaseAppUser.fromData({
    required this.uuid,
     required this.userId,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.createdDate,
  });

  factory BaseAppUser.fromJson(Map<String, dynamic> json) {
    return BaseAppUser.fromData(
      uuid: json['uuid'] ?? _uuid.v4(),
      userId: json['user_id'] as String,
      email: json['email'] ?? '',
      password: json['password_hash'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      createdDate: json['createdDate'] ??
          DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'user_Id': userId,
      'email': email,
      'password_hash': password,
      'first_name': firstName,
      'last_name': lastName,
      'createdDate': createdDate,
    };
  }
}

// class BaseAppUser {
//   final String userId;        
  
//   final String email;
  
//   final String firstName;     
  
//   final String lastName;      
  
//   final String passwordHash; 


//   BaseAppUser({
//     required this.userId,
//     required this.email,
//     required this.firstName,
//     required this.lastName,
//     required this.passwordHash,
//   });

//   // Factory constructor for creating an instance from a map (e.g., from API response)
//   factory BaseAppUser.fromJson(Map json) {
//     return BaseAppUser(
//       userId: json['user_id'] ?? '',
//       email: json['email'] ?? '',
//       firstName: json['first_name'] ?? '',
//       lastName: json['last_name'] ?? '',
//       passwordHash: json['password_hash'] ?? '',
//     );
//   }

//   // Method to convert the model back to JSON
//   Map toJson() {
//     return {
//       'user_id': userId,
//       'email': email,
//       'first_name': firstName,
//       'last_name': lastName,
//       'password_hash': passwordHash,
//     };
//   }
// }