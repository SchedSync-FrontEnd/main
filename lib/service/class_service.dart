// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:schedsync_app/model/class_model.dart';
// // Assuming necessary imports for models and constants
// // Constants derived from UserService [10]
// const String apiHost = '474qnu0tnc.execute-api.ap-southeast-2.amazonaws.com';
// const String stage = 'test';

// class ClassService {

//   // ERROR POPUP (Derived from UserService) [10, 11]
//   void _showErrorDialog(BuildContext context, String message) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text("Error"),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }

//   // ADD CLASS (Uses POST /Classes)
//  Future<ClassModel?> addClass({
//   required BuildContext context,
//   required String userId,
//   required String classCode,
//   required String className,
//   required String timeStart,
//   required String timeEnd,
//   required List<String> daysOfWeek,
//   String? professor,
//   String? location,
// }) async {
//   final uri = Uri.https(apiHost, "/$stage/Class");

//   final response = await http.post(
//     uri,
//     headers: {
//       "Content-Type": "application/json",
//       "user_id": userId,
//     },
//     body: jsonEncode({
//       "classCode": classCode,
//       "className": className,
//       "timeStart": timeStart,
//       "timeEnd": timeEnd,
//       "daysOfWeek": daysOfWeek,
//       "professor": professor,
//       "location": location,
//     }),
//   );

//   print("STATUS: ${response.statusCode}");
//   print("BODY: ${response.body}");

//   final jsonResponse = jsonDecode(response.body);

//   if (response.statusCode != 200) {
//     _showErrorDialog(context, jsonResponse["message"] ?? "Failed to add class.");
//     return null;
//   }

//   return ClassModel(
//     classCode: classCode,
//     userId: userId,
//     className: className,
//     timeStart: timeStart,
//     timeEnd: timeEnd,
//     daysOfWeek: daysOfWeek,
//     professor: professor,
//     location: location,
//   );
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:schedsync_app/model/class_model.dart';
import 'package:schedsync_app/model/base_app_user.dart';

const String apiHost = '474qnu0tnc.execute-api.ap-southeast-2.amazonaws.com';
const String stage = 'test';

class ClassService {
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

// GET CLASS
static Future<List<ClassModel>> getUserClasses(String userId) async {
  final uri = Uri.https(apiHost, "/$stage/Class");

  final response = await http.get(
    uri,
    headers: {
      "Content-Type": "application/json",
      "user_id": userId,
    },
  );

  print("HEADERS: ${response.request?.headers}");
  print("Response body: ${response.body}");

  // First decode API Gateway wrapper
  final outer = jsonDecode(response.body);

  // Then decode the "body" string
  final inner = jsonDecode(outer["body"]);

  // Actual data list
  final List<dynamic> data = inner["data"] ?? [];

  print("Fetched classes: $data");

  return data.map((e) => ClassModel.fromJson(e)).toList();
}


  // ADD CLASS
  Future<ClassModel?> addClass({
    required BuildContext context,
    required String userId, 
    required String classCode,
    required String className,
    required String timeStart,
    required String timeEnd,
    required List<String> daysOfWeek,
    String? professor,
    String? location,
  }) async {
    final uri = Uri.https(apiHost, "/$stage/Class");

    print("user_id = $userId");

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "user_id": userId.toString(),
      },
      body: jsonEncode({
        "classCode": classCode,
        "className": className,
        "timeStart": timeStart,
        "timeEnd": timeEnd,
        "daysOfWeek": daysOfWeek,
        "professor": professor,
        "location": location,
      }),
    );
    print(
      "HEADERS: ${{"Content-Type": "application/json", "user_id": userId.toString()}}",
    );
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode != 200) {
      final json = jsonDecode(response.body);
      _showErrorDialog(context, json["message"] ?? "Failed to add class.");
      return null;
    }

    return ClassModel(
      classCode: classCode,
      userId: userId,
      className: className,
      timeStart: timeStart,
      timeEnd: timeEnd,
      daysOfWeek: daysOfWeek,
      professor: professor,
      location: location,
    );
  }
}
