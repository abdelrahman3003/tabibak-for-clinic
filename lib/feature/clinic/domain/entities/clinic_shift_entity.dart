import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_time_entity.dart';

class ClinicShiftEntity {
  final ClinicTimeEntity? morning;
  final ClinicTimeEntity? evening;

  ClinicShiftEntity({
    required this.morning,
    required this.evening,
  });
}
