import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_time_model.dart';

class ClinicDayWithTimes {
  final int dayId;
  final ClinicTimeModel? morningTime;
  final ClinicTimeModel? eveningTime;

  ClinicDayWithTimes({
    required this.dayId,
    required this.morningTime,
    required this.eveningTime,
  });
}
