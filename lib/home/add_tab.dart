import 'package:flutter/material.dart';

import 'add_class.dart';
import 'add_submissions.dart';
import 'add_exams.dart';

Future<void> showAddTabDialog(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      final theme = Theme.of(context);

      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 260,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 10,
                  offset: Offset(0, 4),
                  color: Colors.black26,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Class Schedule'),
                  onTap: () {
                    Navigator.pop(ctx);          
                    showAddClassSheet(context);  
                  },
                ),
                const Divider(height: 0),

                ListTile(
                  title: const Text('Submission'),
                  onTap: () {
                    Navigator.pop(ctx);
                    showAddSubmissionSheet(context);
                  },
                ),
                const Divider(height: 0),

                ListTile(
                  title: const Text('Exam'),
                  onTap: () {
                    Navigator.pop(ctx);
                    showAddExamSheet(context);
                  },
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                  ),
                  child: const Text('Back'),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
