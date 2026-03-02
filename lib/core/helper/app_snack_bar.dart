import 'package:flutter/material.dart';

class AppSnackBar {
  /// Show a simple snackbar
  static void show(
    BuildContext context, {
    required String message,
    Color backgroundColor = Colors.black87,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      action: action,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    // remove current snackbar before showing new one
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  /// Show success snackbar
  static void success(BuildContext context, String message) {
    show(context, message: message, backgroundColor: Colors.green);
  }

  /// Show error snackbar
  static void error(BuildContext context, String message) {
    show(context, message: message, backgroundColor: Colors.red);
  }

  /// Show warning snackbar
  static void warning(BuildContext context, String message) {
    show(context, message: message, backgroundColor: Colors.orange);
  }
}
