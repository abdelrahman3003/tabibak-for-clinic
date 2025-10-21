import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final TextEditingController? controller;
  final String? lable;
  final IconData? icon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  const AuthField({
    super.key,
    this.controller,
    this.lable,
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
      decoration:
          InputDecoration(hintText: lable, contentPadding: EdgeInsets.all(14)),
    );
  }
}
