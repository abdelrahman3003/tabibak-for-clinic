import 'package:flutter/material.dart';

class AppTextError extends StatelessWidget {
  const AppTextError({super.key, required this.error});
  final String error;
  @override
  Widget build(BuildContext context) {
    return Text(error);
  }
}
