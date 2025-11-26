import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class BaseAppUser {
  final String userId;
  final String email;
  final String firstName;
  final String lastName;

  // Store raw password only in local session (NOT saved to API)
  final String password;

  BaseAppUser({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
  });

  // Create object from API response (login)
  factory BaseAppUser.fromJson(Map<String, dynamic> json, String rawPassword) {
    return BaseAppUser(
      userId: json['user_id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      password: rawPassword, // keep raw for session
    );
  }

  // Convert to JSON (rarely used, but keep it clean)
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      // Do NOT include password in API outputs
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