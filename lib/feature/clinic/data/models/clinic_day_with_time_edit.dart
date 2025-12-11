import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_time_model.dart';

class ClinicDayWithTimeEdit {
  final int dayId;
  final int? workingDayId;
  final int? shiftId;
  final int? morningTimeId;
  final int? eveningTimeId;
  final ClinicTimeModel? morningTime;
  final ClinicTimeModel? eveningTime;

  ClinicDayWithTimeEdit({
    required this.dayId,
    this.workingDayId,
    this.shiftId,
    this.morningTimeId,
    this.eveningTimeId,
    this.morningTime,
    this.eveningTime,
  });
}
