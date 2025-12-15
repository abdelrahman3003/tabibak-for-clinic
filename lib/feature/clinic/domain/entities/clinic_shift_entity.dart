import 'package:flutter/material.dart';

class ClinicShiftEntity {
  final TimeOfDay? morningStart;
  final TimeOfDay? morningEnd;
  final TimeOfDay? eveningStart;
  final TimeOfDay? eveningEnd;

  ClinicShiftEntity(
    this.morningStart,
    this.morningEnd,
    this.eveningStart,
    this.eveningEnd,
  );
}
