import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_info_model.dart';

abstract class ClinicRemoteData {
  Future<int> createClinicInfo(ClinicInfoModel clinicInfoModel);
}
