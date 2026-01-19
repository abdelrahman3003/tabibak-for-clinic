import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/functions/format_time.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_entity.dart';

class ClinicShiftModel extends ClinicShiftEntity {
  ClinicShiftModel(
    TimeOfDay? morningStart,
    TimeOfDay? morningEnd,
    TimeOfDay? eveningStart,
    TimeOfDay? eveningEnd, {
    super.shiftId,
  }) : super(
          morningStart: morningStart,
          morningEnd: morningEnd,
          eveningStart: eveningStart,
          eveningEnd: eveningEnd,
        );

  factory ClinicShiftModel.fromJson(Map<String, dynamic> json) {
    return ClinicShiftModel(
      parseTime(json['morning_start']),
      parseTime(json['morning_end']),
      parseTime(json['evening_start']),
      parseTime(json['evening_end']),
      shiftId: json['id'],
    );
  }
}
