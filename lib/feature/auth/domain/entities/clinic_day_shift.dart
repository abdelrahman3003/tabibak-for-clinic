import 'package:flutter/material.dart';

class WorkDayShift {
  final int day;
  final TimeOfDay? morningStart;
  final TimeOfDay? morningEnd;
  final TimeOfDay? eveningStart;
  final TimeOfDay? eveningEnd;

  WorkDayShift({
    required this.day,
    this.morningStart,
    this.morningEnd,
    this.eveningStart,
    this.eveningEnd,
  });
}
