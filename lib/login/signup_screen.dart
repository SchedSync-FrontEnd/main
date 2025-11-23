import 'package:flutter/material.dart';
import 'package:schedsync_app/service/login_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen(
    this.switchTheme, {
    super.key,
    required this.successRegister,
    required this.cancelRegister,
  });

  final void Function() switchTheme;
  final void Function(String message) successRegister;
  final VoidCallback cancelRegister;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginService = LoginService();

  String _username = '';
  String _firstName = '';
  String _lastName = '';
  String _password = '';
  String _confirmPassword = '';

  bool _showPassword = false;
  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.cancelRegister,
        ),
        actions: [
          IconButton(
            onPressed: widget.switchTheme,
            icon: const Icon(Icons.brightness_6),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // LOGO
              Image.asset(
                'assets/img/logo.png',
                width: 260,
                height: 260,
                color: isDark ? Colors.white : null,
                colorBlendMode: BlendMode.srcIn,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // USERNAME
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Username'),
                      onSaved: (val) => _username = val!.trim(),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Please enter a username.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // FIRST NAME
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'First name'),
                      onSaved: (val) => _firstName = val!.trim(),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Please enter your first name.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // LAST NAME
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Last name'),
                      onSaved: (val) => _lastName = val!.trim(),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Please enter your last name.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // PASSWORD
                    TextFormField(
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                      onSaved: (val) => _password = val ?? '',
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please enter a password.';
                        }
                        if (val.length < 6) {
                          return 'Password must be at least 6 characters.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // CONFIRM PASSWORD
                    TextFormField(
                      obscureText: !_showPassword,
                      decoration: const InputDecoration(labelText: 'Confirm password'),
                      onSaved: (val) => _confirmPassword = val ?? '',
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please confirm your password.';
                        }
                        if (val != _password && _password.isNotEmpty) {
                          return 'Passwords do not match.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isSending ? null : widget.cancelRegister,
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isSending ? null : _submit,
                            child: _isSending
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Text('Register'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    if (_password != _confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    final msg = await _loginService.signUpRequest(
      context: context,
      username: _username,
      password: _password,
      firstName: _firstName,
      lastName: _lastName,
    );

    setState(() {
      _isSending = false;
    });

    if (msg != null) {
      widget.successRegister(msg);
    }
  }
}
