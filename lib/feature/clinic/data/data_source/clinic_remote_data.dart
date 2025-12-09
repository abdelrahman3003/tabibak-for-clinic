import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_day_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_info_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_time_model.dart';

abstract class ClinicRemoteData {
  Future<List<ClinicInfoModel>> getClinicInfo();
  Future<int> createClinicInfo(ClinicInfoModel clinicInfoModel);
  Future<int> createClinicTime(ClinicTimeModel clinicTimeModel);
  Future<List<ClinicDayModel>> getAllDays();

  Future<void> addWorkingDayWithShifts(
      {required int dayId,
      required ClinicTimeModel morningTimeModel,
      required ClinicTimeModel eveningTimeModel,
      required int clinicId});
}
