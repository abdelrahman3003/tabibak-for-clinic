import 'package:image_picker/image_picker.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/model/dotcor_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/model/education_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/model/specialty_model.dart';

abstract class DoctorProfileRemoteData {
  Future<DoctorModel?> getDoctor();
  Future<void> uploadImage(String imageUrl);
  Future<void> updateDoctorInfo(
      {String? name, String? phone, String? address, String? bio});
  Future<void> updateEducation(
      {required EducationModel educationModel, XFile? file});
  Future<void> updateSpecialty({required int specialtyId});
  Future<List<SpecialtyModel>> getSpecialties();
}
