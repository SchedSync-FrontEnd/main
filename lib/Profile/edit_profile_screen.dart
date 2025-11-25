import 'package:flutter/material.dart'; 
import 'package:schedsync_app/model/base_app_user.dart'; 
import 'package:schedsync_app/service/user_service.dart'; 
import 'package:schedsync_app/Profile/change_password_screen.dart'; 

class EditProfile extends StatefulWidget { 

  const EditProfile({
    super.key,
    required this.currentUser, 
    required this.onProfileUpdated,
  });

  final BaseAppUser currentUser; 
  final void Function(BaseAppUser updatedUser) onProfileUpdated;

  @override 
  State createState() { 
    return _EditProfileState(); 
  }

}

class _EditProfileState extends State<EditProfile> { 

  final _userService = UserService();
  final _formKey = GlobalKey<FormState>(); 


  late String _enteredFirstName;
  late String _enteredLastName;
  late String _enteredUsername; 
  
  var _isSending = false; 

  @override
  void initState() {
    super.initState();
    // Initialize fields with current user data
    _enteredFirstName = widget.currentUser.firstName;
    _enteredLastName = widget.currentUser.lastName;
    _enteredUsername = widget.currentUser.email; 
  }

  void _saveProfile() async { 

    if (_formKey.currentState!.validate()) { 
      _formKey.currentState!.save(); 

      setState(() { 
        _isSending = true; 
      });

      // Call service to update, passing uuid and username
      BaseAppUser? updatedUser = await _userService.updateProfile(
        context: context,
        uuid: widget.currentUser.uuid, 
        username: _enteredUsername, 
        firstName: _enteredFirstName,
        lastName: _enteredLastName,
      );

      if (updatedUser != null) { 
        widget.onProfileUpdated(updatedUser);
        Navigator.of(context).pop(); 
      } else {
        setState(() { 
          _isSending = false; 
        });
      }
    }
  }

  @override 
  Widget build(BuildContext context) { 
    final textColor = Theme.of(context).colorScheme.onBackground;

    return Scaffold( 
      appBar: AppBar( 
        title: const Text('Edit Profile'), 
      ), //
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form( 
          key: _formKey, 
          child: Column( 
            children: [
              // Profile Picture Editing UI
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar( 
                    backgroundColor: Colors.black,
                    radius: 50,
                    child: Icon(Icons.person, size: 80, color: Colors.white,), //
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: InkWell(
                      onTap: () {
                        // image selection logic here
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.edit, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // FIRST NAME 
              TextFormField(
                initialValue: _enteredFirstName,
                maxLength: 50, 
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: textColor),
                decoration: const InputDecoration(
                  label: Text('First Name'), 
                ),
                validator: (value) { 
                  if (value == null || value.isEmpty || value.trim().length <= 1) {
                    return 'Must be at least 2 Characters';
                  }
                  return null;
                },
                enabled: !_isSending, 
                onSaved: (value) { 
                  _enteredFirstName = value!;
                },
              ),
              const SizedBox(height: 16),
              
              // LAST NAME 
              TextFormField(
                initialValue: _enteredLastName,
                maxLength: 50, 
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: textColor),
                decoration: const InputDecoration(
                  label: Text('Last Name'), 
                ),
                validator: (value) { 
                  if (value == null || value.isEmpty || value.trim().length <= 1) {
                    return 'Must be at least 2 Characters';
                  }
                  return null;
                },
                enabled: !_isSending, 
                onSaved: (value) { 
                  _enteredLastName = value!;
                },
              ),
              const SizedBox(height: 16),

              
              TextFormField(
                initialValue: _enteredUsername,
                maxLength: 50, 
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: textColor),
                decoration: const InputDecoration(
                  label: Text('Username'), 
                ),
                validator: (value) { 
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your username.';
                  }
                  return null;
                },
                enabled: !_isSending,
                onSaved: (value) { 
                  _enteredUsername = value!.trim();
                },
              ),
              const SizedBox(height: 16),
              
              // Change Password Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isSending ? null : () {
                   
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => ChangePasswordScreen(
                          currentUser: widget.currentUser, 
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.lock_reset),
                  label: const Text('Change Password'),
                ),
              ),

              const SizedBox(height: 24),
              
              // ACTION BUTTONS 
              Row(
                mainAxisAlignment: MainAxisAlignment.end, 
                children: [ 
                  TextButton( 
                    onPressed: _isSending ? null : () { 
                      _formKey.currentState!.reset(); 
                      // Re-initialize values after reset
                      setState(() {
                         _enteredFirstName = widget.currentUser.firstName;
                         _enteredLastName = widget.currentUser.lastName;
                         _enteredUsername = widget.currentUser.email;
                      });
                    },
                    child: const Text('Reset'), 
                  ), 
                  ElevatedButton( 
                    onPressed: _isSending ? null : _saveProfile, 
                    child: _isSending 
                      ? const SizedBox( 
                          height: 16, 
                          width: 16, 
                          child: CircularProgressIndicator(strokeWidth: 2), 
                        )
                      : const Text('Save Changes'), 
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