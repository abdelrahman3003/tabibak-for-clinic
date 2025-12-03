import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_info_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_shift_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_time_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_working_day_model.dart';

abstract class ClinicRemoteData {
  Future<int> createClinicInfo(ClinicInfoModel clinicInfoModel);
  Future<int> createClinicWorkingDay(
      ClinicWorkingDayModel clinicWorkingDayModel);
  Future<int> createClinicShift(ClinicShiftModel clinicShiftModel);
  Future<int> createClinicTime(ClinicTimeModel clinicTimeModel);
}
