import 'package:flutter/material.dart';

class ClinicShiftEntity {
  final int? shiftId;
  final TimeOfDay? start;
  final TimeOfDay? end;
  final bool? isActive;
  final String? shiftType;
  ClinicShiftEntity({
    this.shiftId,
    this.start,
    this.end,
    this.isActive = false,
    this.shiftType,
  });
}
