import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final IconData? icon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;

  const AuthField({
    super.key,
    this.controller,
    this.label,
    this.icon,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: label,
        contentPadding: const EdgeInsets.all(14),
        prefixIcon: icon != null ? Icon(icon) : null,
      ),
    );
  }
}
