// ignore_for_file: deprecated_member_use

import 'package:beszel_fpg/core/theme/theme_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const LoginButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
           BoxShadow(
      color: Colors.black.withOpacity(
        Theme.of(context).brightness == Brightness.dark ? 0.5 : 0.18,
      ),
      blurRadius: Theme.of(context).brightness == Brightness.dark ? 32 : 20,
      spreadRadius: 2,
      offset: const Offset(0, 8),
    ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: CupertinoButton(
        color: context.buttonColor,
        borderRadius: BorderRadius.circular(12),
        padding: const EdgeInsets.symmetric(vertical: 18),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.arrow_right, size: 20, color: context.subtextColor),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: context.subtextColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
