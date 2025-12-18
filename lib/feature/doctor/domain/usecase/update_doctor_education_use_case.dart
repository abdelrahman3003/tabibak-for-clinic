import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/education_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/repos/doctor_profile_repo.dart';

class UpdateDoctorEducationUseCase {
  final DoctorProfileRepo doctorProfileRepo;

  UpdateDoctorEducationUseCase({required this.doctorProfileRepo});
  Future<Either<ApiErrorModel, void>> call(
      {EducationEntity? educationEntity, List<XFile?>? files}) async {
    return doctorProfileRepo.updateEducation(
        educationEntity: educationEntity, files: files);
  }
}
