import 'package:flutter/material.dart';

String formatTime(TimeOfDay t) {
  final hour = t.hour.toString().padLeft(2, '0');
  final minute = t.minute.toString().padLeft(2, '0');
  return "$hour:$minute";
}
