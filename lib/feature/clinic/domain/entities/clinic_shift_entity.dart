import 'package:flutter/material.dart';

class ClinicShiftEntity {
  final int? shiftId;
  final TimeOfDay? start;
  final TimeOfDay? end;
  final bool? isActive;

  ClinicShiftEntity({
    this.shiftId,
    this.start,
    this.end,
    this.isActive = false,
  });
}
