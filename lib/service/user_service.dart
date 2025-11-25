import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:schedsync_app/home/home_screen.dart';
import 'package:schedsync_app/model/base_app_user.dart';

// Reusing config constants [1]
const bool useFakeBackend = true; 
const String apiHost = 'your-api-id.execute-api.ap-southeast-1.amazonaws.com'; 
const String stage = 'prod'; 

class UserService {

  Future<BaseAppUser?> updateProfile({
    required BuildContext context,
    required String uuid, // Restored to uuid
    required String username, // Restored to username
    required String firstName,
    required String lastName,
  }) async {

    if (useFakeBackend) { //
      await Future.delayed(const Duration(seconds: 1)); 

      if (username.isEmpty || firstName.isEmpty || lastName.isEmpty) { 
        _showErrorDialog(context, 'Please fill in all required fields.'); 
        return null;
      }

      // Return updated mock user data
      return BaseAppUser.fromData( 
        uuid: uuid,
        userId: UserId,
        email: username,
        password: '***', 
        firstName: firstName,
        lastName: lastName,
        createdDate: DateTime.now().toIso8601String(), 
      );
    }

    // REAL API CALL SAMPLE 
    final uri = Uri.https( 
      apiHost, 
      '/$stage/profile/$uuid', // Targeting API using uuid
    );

    final response = await http.post( 
      uri, 
      headers: {'Content-Type': 'application/json'}, 
      body: jsonEncode({ 
        'username': username, // Using 'username' key
        'firstName': firstName,
        'lastName': lastName,
      }), 
    );

   if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      // Adjust based on your Lambda response structure
      final userJson = body['user'] as Map<String, dynamic>;
      return BaseAppUser.fromJson(userJson);
    } else {
      _showErrorDialog(
        context,
        'update failed (${response.statusCode}). Please try again.',
      );
      return null;
    }
  }
  
  Future<String?> changePasswordRequest({
    required BuildContext context,
    required String uuid, // Restored to uuid
    required String oldPassword,
    required String newPassword,
  }) async {

    if (useFakeBackend) { 
      await Future.delayed(const Duration(seconds: 1)); 

      if (oldPassword.isEmpty || newPassword.isEmpty) {
        _showErrorDialog(context, 'Please enter both old and new passwords.'); 
        return null;
      }
      return 'Password updated successfully.';
    }

    // REAL API CALL SAMPLE 
    final uri = Uri.https( 
      apiHost, 
      '/$stage/change-password', 
    );

    final response = await http.post( 
      uri, 
      headers: {'Content-Type': 'application/json'}, 
      body: jsonEncode({ 
        'uuid': uuid, // Pass uuid
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) { 
      final body = jsonDecode(response.body) as Map; 
      return body['message'] ?? 'Password updated successfully.';
    } else if (response.statusCode == 401) {
      _showErrorDialog(context, 'Incorrect old password.'); 
      return null;
    } else {
      _showErrorDialog( 
        context,
        'Failed to change password (${response.statusCode}).',
      );
      return null;
    }
  }

  void _showErrorDialog(BuildContext context, String message) { // [9]
    showDialog( //
      context: context, //
      builder: (ctx) => AlertDialog( //
        title: const Text('Error'), //
        content: Text(message), //
        actions: [ //
          TextButton( //
            onPressed: () => Navigator.of(ctx).pop(), //
            child: const Text('OK'), //
          ), //
        ], //
      ), //
    ); //
  }
}