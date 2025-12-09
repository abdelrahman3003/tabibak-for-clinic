import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_time_entity.dart';

class ClinicTimeModel extends ClinicTimeEntity {
  ClinicTimeModel({
    required super.start,
    required super.end,
  });

  factory ClinicTimeModel.fromJson(Map<String, dynamic> json) {
    return ClinicTimeModel(
      start: json["start"],
      end: json["end"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "start": _formatTime(start),
      "end": _formatTime(end),
    };
  }

  String _formatTime(TimeOfDay? t) {
    final hour = t?.hour.toString().padLeft(2, '0');
    final minute = t?.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }
}

extension ClinicTimeMapper on ClinicTimeEntity {
  ClinicTimeModel toModel() {
    return ClinicTimeModel(
      start: start,
      end: end,
    );
  }
}
