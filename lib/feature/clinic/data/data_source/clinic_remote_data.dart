import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_address_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_day_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_info_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_working_day_model.dart';

abstract class ClinicRemoteData {
  Future<List<ClinicInfoModel>> getClinicInfo();
  Future<int> createClinicInfo(ClinicInfoModel clinicInfoModel);
  Future<List<ClinicDayModel>> getAllDays();

  Future<void> saveClinicWorkingDays({
    required int clinicId,
    required List<ClinicWorkingDayModel> selectedDays,
  });
  Future<List<ClinicWorkingDayModel>> getClinicSchedule(
      {required int clinicId});
  Future<void> saveClinicInfo({required ClinicInfoModel clinicInfoModel});
  Future<void> saveClinicAddress({required ClinicAddressModel clinicAddressModel});
}
