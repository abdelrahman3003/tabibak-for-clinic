import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_time_model.dart';

class ClinicDayWithTimesModel {
  final int dayId;
  final ClinicTimeModel? morningTime;
  final ClinicTimeModel? eveningTime;

  ClinicDayWithTimesModel({
    required this.dayId,
    required this.morningTime,
    required this.eveningTime,
  });
}
