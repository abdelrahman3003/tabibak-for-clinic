import 'package:flutter/material.dart';

class TextFormFiledWidget extends StatelessWidget {
  const TextFormFiledWidget({super.key, this.controller, required this.label});
  final TextEditingController? controller;
  final String label;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context).textTheme.titleMedium,
        contentPadding: EdgeInsets.zero,
        border: const UnderlineInputBorder(),
        fillColor: Colors.transparent,
        filled: true,
      ),
    );
  }
}
