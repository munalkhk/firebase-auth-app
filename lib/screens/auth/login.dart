import 'package:blog_app/extensions/theme_extension.dart';
import 'package:blog_app/screens/tab_screen.dart';
import 'package:blog_app/services/auth_service.dart';
import 'package:blog_app/widgets/auth/login_form.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  Future<void> _onSubmit(String email, String password) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _authService.signInWithEmail(email, password);
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const TabScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      _showError('Authentication failed: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: []), //
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
                  'Welcome back',
                  style: context.textTheme.titleLarge!.copyWith(fontSize: 36),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Sign in to continue reading',
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                LoginForm(
                  onSubmit: _onSubmit,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
