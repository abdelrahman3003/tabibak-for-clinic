import 'package:tabibak_for_clinic/feature/doctor/data/model/dotcor_model.dart';

abstract class DoctorProfileRemoteData {
  Future<DoctorModel?> getDoctor();
  Future<void> uploadImage(String imageUrl);
  Future<void> updateDoctorInfo(
      {String? name, String? phone, String? address, String? bio});
  //  Future<void> updateEducation({String? country ,String? university,int?degree?})
}
