import 'package:beszel_fpg/core/theme/theme_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/login_text_field.dart';
import '../widgets/login_button.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Beszel',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: context.textColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Please sign in to your account',
                  style: TextStyle(
                    fontSize: 16,
                    color: context.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 32),
                LoginTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  icon: CupertinoIcons.mail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                LoginTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  icon: CupertinoIcons.lock,
                  obscureText: _isObscured,
                  keyboardType: TextInputType.visiblePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscured ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                      color: context.secondaryTextColor,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),
                LoginButton(
                  text: 'Sign in',
                  onPressed: () {
                    // TODO: Implement authentication logic
                  },
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    // TODO: Implement forgot password navigation
                  },
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: context.secondaryTextColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
