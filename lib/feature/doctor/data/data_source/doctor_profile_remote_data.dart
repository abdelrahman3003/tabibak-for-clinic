import 'package:tabibak_for_clinic/feature/doctor/data/model/dotcor_model.dart';

abstract class DoctorProfileRemoteData {
  Future<DoctorModel?> getDoctor();
  Future<void> uploadImage(String imageUrl);
}
