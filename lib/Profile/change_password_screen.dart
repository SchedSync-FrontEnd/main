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
  bool _isSending = false; 
  bool _showOldPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  void _submitPasswordChange() async { 

    if (_formKey.currentState!.validate()) { 
      _formKey.currentState!.save(); 

      if (_newPassword != _confirmPassword) {
        return;
      }

      setState(() { 
        _isSending = true; 
      });

      final successMessage = await _userService.changePasswordRequest(
        context: context,
        uuid: widget.currentUser.uuid, 
        oldPassword: _oldPassword,
        newPassword: _newPassword,
      );

      if (mounted) {
        setState(() {
          _isSending = false;
        });
        
        if (successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(successMessage)),
          );
          Navigator.of(context).pop(); 
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
        title: const Text('Change Password'), 
      ),
      body: Padding( 
        padding: const EdgeInsets.all(16),
        child: Form( 
          key: _formKey, 
          child: Column(
            children: [
              // OLD PASSWORD FIELD
              TextFormField(
                style: Theme.of(context).textTheme.titleMedium,
                obscureText: !_showOldPassword, 
                decoration: InputDecoration(
                  label: const Text('Old Password'),
                  suffixIcon: IconButton(
                    onPressed: () { setState(() => _showOldPassword = !_showOldPassword); },
                    icon: Icon(_showOldPassword ? Icons.visibility_off : Icons.visibility), 
                  ),
                ),
                validator: (value) { 
                  if (value == null || value.isEmpty) { return 'Please enter your current password.'; }
                  return null;
                },
                enabled: !_isSending,
                onSaved: (value) => _oldPassword = value!,
              ),
              const SizedBox(height: 16),

              // NEW PASSWORD FIELD
              TextFormField(
                style: Theme.of(context).textTheme.titleMedium,
                obscureText: !_showNewPassword,
                decoration: InputDecoration(
                  label: const Text('New Password'),
                  suffixIcon: IconButton(
                    onPressed: () { setState(() => _showNewPassword = !_showNewPassword); },
                    icon: Icon(_showNewPassword ? Icons.visibility_off : Icons.visibility),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) { return 'Password must be at least 6 characters.'; }
                  _newPassword = value;
                  return null;
                },
                enabled: !_isSending,
                onSaved: (value) => _newPassword = value!,
              ),
              const SizedBox(height: 16),

              // CONFIRM NEW PASSWORD FIELD
              TextFormField(
                style: Theme.of(context).textTheme.titleMedium,
                obscureText: !_showConfirmPassword,
                decoration: InputDecoration(
                  label: const Text('Confirm New Password'),
                  suffixIcon: IconButton(
                    onPressed: () { setState(() => _showConfirmPassword = !_showConfirmPassword); },
                    icon: Icon(_showConfirmPassword ? Icons.visibility_off : Icons.visibility),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) { return 'Please confirm your new password.'; }
                  if (value != _newPassword) { return 'Passwords do not match.'; }
                  return null;
                },
                enabled: !_isSending,
                onSaved: (value) => _confirmPassword = value!,
              ),
              const SizedBox(height: 24),
              
              
              Row(
                mainAxisAlignment: MainAxisAlignment.end, 
                children: [ 
                  TextButton( 
                    onPressed: _isSending ? null : () { 
                      _formKey.currentState!.reset(); 
                    },
                    child: const Text('Reset'), 
                  ), 
                  ElevatedButton( 
                    onPressed: _isSending ? null : _submitPasswordChange, 
                    child: _isSending 
                      ? const SizedBox( 
                          height: 16, 
                          width: 16, 
                          child: CircularProgressIndicator(strokeWidth: 2), 
                        )
                      : const Text('Change Password'), 
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}