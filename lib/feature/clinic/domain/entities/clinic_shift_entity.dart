import 'package:flutter/material.dart';

class ClinicShiftEntity {
  final int? shiftId;
  final TimeOfDay? start;
  final TimeOfDay? end;

  ClinicShiftEntity({
    this.shiftId,
    this.start,
    this.end,
  });
}
