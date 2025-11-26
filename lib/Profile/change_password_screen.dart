import 'package:flutter/material.dart';
import 'package:schedsync_app/model/base_app_user.dart';
import 'package:schedsync_app/service/user_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({
    super.key,
    required this.currentUser,
  });

  final BaseAppUser currentUser;

  @override
  State createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _userService = UserService();
  final _formKey = GlobalKey<FormState>();

  String _oldPassword = '';
  String _newPassword = '';
  String _confirmPassword = '';

  bool _sending = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    if (_newPassword != _confirmPassword) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Passwords do not match.")));
      return;
    }

    setState(() => _sending = true);

    final msg = await _userService.changePasswordRequest(
      context: context,
      userId: widget.currentUser.userId,
      oldPassword: _oldPassword,
      newPassword: _newPassword,
    );

    setState(() => _sending = false);

    if (msg != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change Password (Test Mode)")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Old Password"),
                validator: (v) => v!.isEmpty ? "Enter old password" : null,
                onSaved: (v) => _oldPassword = v!,
              ),
              const SizedBox(height: 12),

              TextFormField(
                decoration: const InputDecoration(labelText: "New Password"),
                validator: (v) => v!.length < 6 ? "Min 6 characters" : null,
                onSaved: (v) => _newPassword = v!,
              ),
              const SizedBox(height: 12),

              TextFormField(
                decoration: const InputDecoration(labelText: "Confirm Password"),
                validator: (v) => v!.isEmpty ? "Confirm password" : null,
                onSaved: (v) => _confirmPassword = v!,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _sending ? null : _submit,
                child:
                    _sending ? const CircularProgressIndicator() : const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
