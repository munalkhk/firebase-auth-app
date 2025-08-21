import 'package:blog_app/screens/auth/login.dart';
import 'package:blog_app/widgets/custom-widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class SignupForm extends StatefulWidget {
  final bool isLoading;
  final void Function(String email, String password, String username) onSubmit;

  const SignupForm({
    super.key,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _username = '';

  void _trySubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSubmit(_email, _password, _username);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormField(
                key: const ValueKey('email'),
                labelText: 'Email Address',
                validator: (value) => value == null || !value.contains('@')
                    ? 'Enter a valid email'
                    : null,
                onSaved: (value) => _email = value!,
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                key: const ValueKey('username'),
                labelText: 'Username',
                validator: (value) => value == null || value.length < 4
                    ? 'Enter at least 4 characters'
                    : null,
                onSaved: (value) => _username = value!,
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                key: const ValueKey('password'),
                labelText: 'Password',
                obscureText: true,
                validator: (value) => (value?.length ?? 0) < 6
                    ? 'Password must be at least 6 characters'
                    : null,
                onSaved: (value) => _password = value!,
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _trySubmit,
                  child: widget.isLoading
                      ? const Text('Loading...')
                      : const Text('Signup'),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (ctx) => const LoginScreen()),
                    (route) => false,
                  );
                },
                child: const Text('Already have an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
