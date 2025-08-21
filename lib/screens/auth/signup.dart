import 'package:blog_app/extensions/theme_extension.dart';
import 'package:blog_app/screens/tab_screen.dart';
import 'package:blog_app/services/auth_service.dart';
import 'package:blog_app/widgets/auth/signup_form.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _authService = AuthService();
  bool _isLoading = false;

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: context.colorScheme.errorContainer,
        content: Text(msg, style: TextStyle(color: context.colorScheme.error)),
      ),
    );
  }

  void onSubmit(String email, String password, String username) async {
    setState(() => _isLoading = true);
    try {
      await _authService.signUpWithEmail(email, password, username);
      if (mounted) {
        //Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const TabScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      _showError('SignUp with email-pass failed: $e');
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 5,
              right: 20,
              left: 20,
              bottom: 80,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox.shrink(),
                const SizedBox(height: 20),
                Text(
                  'Create account',
                  style: context.textTheme.titleLarge!.copyWith(fontSize: 36),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Join to read and share blog posts',
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                SignupForm(onSubmit: onSubmit, isLoading: _isLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
