import 'package:flutter/material.dart';
import 'package:schedsync_app/model/base_app_user.dart';

// TEMPORARY TEST MODE
class UserService {
  Future<BaseAppUser?> updateProfile({
    required BuildContext context,
    required String userId,
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    return BaseAppUser(
      userId: userId,
      email: email,
      password: "***",
      firstName: firstName,
      lastName: lastName,
    );
  }

  Future<String?> changePasswordRequest({
    required BuildContext context,
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return "Password updated (TEST MODE — no AWS call)";
  }
}
