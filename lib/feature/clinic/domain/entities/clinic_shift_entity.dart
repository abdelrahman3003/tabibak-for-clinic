import 'package:flutter/material.dart';

class ClinicShiftEntity {
  final int? shiftId;
  final TimeOfDay? morningStart;
  final TimeOfDay? morningEnd;
  final TimeOfDay? eveningStart;
  final TimeOfDay? eveningEnd;

  ClinicShiftEntity({
    this.shiftId,
    this.morningStart,
    this.morningEnd,
    this.eveningStart,
    this.eveningEnd,
  });
}
