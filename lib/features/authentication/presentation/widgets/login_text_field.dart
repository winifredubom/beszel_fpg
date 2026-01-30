// ignore_for_file: deprecated_member_use

import 'package:beszel_fpg/core/theme/theme_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;

  const LoginTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor, width: 1.2),
        boxShadow: [
            BoxShadow(
            color: Colors.black.withOpacity(
              Theme.of(context).brightness == Brightness.light ? 0.25 : 0.08,
            ),
            blurRadius: Theme.of(context).brightness == Brightness.light ? 16 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(color: context.textColor),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: context.secondaryTextColor),
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: TextStyle(color: context.secondaryTextColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
      ),
    );
  }
}
