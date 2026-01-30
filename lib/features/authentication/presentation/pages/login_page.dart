import 'package:beszel_fpg/core/constants/app_constants.dart';
import 'package:beszel_fpg/core/network/error_helper.dart';
import 'package:beszel_fpg/core/theme/theme_extensions.dart';
import 'package:beszel_fpg/features/authentication/presentation/pages/forgot_password_page.dart';
import 'package:beszel_fpg/features/authentication/service/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
                      _isObscured
                          ? CupertinoIcons.eye_slash
                          : CupertinoIcons.eye,
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
                  onPressed: () async {
                    final credentials = {
                      'identity': _emailController.text.trim(),
                      'password': _passwordController.text,
                    };
                    final loginFuture = ref.read(
                      loginProvider(credentials).future,
                    );

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) =>
                          const Center(child: CircularProgressIndicator()),
                    );

                    try {
                       await loginFuture;
                      if (context.mounted) {
                       // Navigator.of(context).pop(); // Remove loading dialog
                        context.go(
                          AppRoutes.dashboard,
                        );
                      }
                    } catch (e, stack) {
                      if (context.mounted) {
                        Navigator.of(context).pop(); // Remove loading dialog
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ErrorView(
                                error: e,
                                stackTrace: stack,
                                onRetry: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    context.pushNamed('forgot_password');
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
