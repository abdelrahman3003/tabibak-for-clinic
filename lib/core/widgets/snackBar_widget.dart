import 'package:flutter/material.dart';

showSnackBar({required BuildContext context, required String messege}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(messege)),
  );
}
