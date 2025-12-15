import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_day_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_time_model.dart';

class ClinicDayWithTimesModel {
  final ClinicDayModel day;
  final ClinicTimeModel? morningTime;
  final ClinicTimeModel? eveningTime;

  ClinicDayWithTimesModel({
    required this.day,
    required this.morningTime,
    required this.eveningTime,
  });
}
