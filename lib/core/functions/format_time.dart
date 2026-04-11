import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

String formatTime(TimeOfDay t) {
  final hour = t.hour.toString().padLeft(2, '0');
  final minute = t.minute.toString().padLeft(2, '0');
  return "$hour:$minute:00";
}

TimeOfDay? parseTime(String? time) {
  if (time == null) return null;
  final parts = time.split(':');
  return TimeOfDay(
    hour: int.parse(parts[0]),
    minute: int.parse(parts[1]),
  );
}

String formatDayMonth(String date) {
  final dateTime = DateTime.parse(date);
  return DateFormat('dd/MM').format(dateTime);
}
