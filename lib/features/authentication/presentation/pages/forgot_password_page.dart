import 'package:beszel_fpg/core/theme/theme_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/login_text_field.dart';
import '../widgets/login_button.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: context.textColor),
          onPressed: () {
            context.goNamed('login_page');
          },
        ),
      ),
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
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: context.textColor,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Enter email address to reset password',
                  style: TextStyle(
                    fontSize: 18,
                    color: context.secondaryTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                LoginTextField(
                  controller: _emailController,
                  hintText: 'name@example.com',
                  icon: CupertinoIcons.mail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),
                LoginButton(
                  text: 'Reset Password',
                  onPressed: () {
                    // TODO: Implement reset password logic
                  },
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () {
                    // TODO: Implement navigation or instructions
                  },
                  child: Text(
                    'Command line instructions',
                    style: TextStyle(
                      color: context.secondaryTextColor,
                      decoration: TextDecoration.underline,
                      fontSize: 16,
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
