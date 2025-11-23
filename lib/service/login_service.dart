import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:schedsync_app/model/base_app_user.dart';

// set  to `false` once kapag okay na yung API  
const bool useFakeBackend = true;

// example AWS API config (adjust when API Gateway is live)
const String apiHost = 'your-api-id.execute-api.ap-southeast-1.amazonaws.com';
const String stage = 'prod'; // e.x. 'prod' or 'dev'

class LoginService {
  Future<BaseAppUser?> loginRequest({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    if (useFakeBackend) {
      // fake login – accepts any non-empty username/password temporary
      await Future.delayed(const Duration(seconds: 1));
      if (username.isEmpty || password.isEmpty) {
        _showErrorDialog(context, 'Please enter username and password.');
        return null;
      }
      return BaseAppUser(
        username: username,
        password: password,
        firstName: 'Test',
        lastName: 'User',
      );
    }

    // --- REAL API CALL SAMPLE (for later AWS integration) ---
    final uri = Uri.https(
      apiHost,
      '/$stage/login',
    );

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
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
        'Login failed (${response.statusCode}). Please try again.',
      );
      return null;
    }
  }

  Future<String?> signUpRequest({
    required BuildContext context,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    if (useFakeBackend) {
      await Future.delayed(const Duration(seconds: 1));

      if (username.isEmpty ||
          password.isEmpty ||
          firstName.isEmpty ||
          lastName.isEmpty) {
        _showErrorDialog(context, 'Please fill in all fields.');
        return null;
      }

      return 'Registration successful for $username';
    }

    // REAL API CALL SAMPLE!! (for later AWS integration) 
    final uri = Uri.https(
      apiHost,
      '/$stage/register',
    );

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body['message'] ?? 'Registration successful.';
    } else {
      _showErrorDialog(
        context,
        'Registration failed (${response.statusCode}).',
      );
      return null;
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
