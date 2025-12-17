import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/repos/doctor_profile_repo.dart';

class UploadImageProfileUseCase {
  final DoctorProfileRepo doctorProfileRepo;

  UploadImageProfileUseCase({required this.doctorProfileRepo});
  Future<Either<ApiErrorModel, void>> call(String imagePath) async {
    return await doctorProfileRepo.uploadImage(imagePath);
  }
}
