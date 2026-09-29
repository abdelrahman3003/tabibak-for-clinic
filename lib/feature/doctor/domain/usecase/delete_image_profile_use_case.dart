import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/repos/doctor_profile_repo.dart';

class DeleteImageProfileUseCase {
  final DoctorProfileRepo doctorProfileRepo;

  DeleteImageProfileUseCase({required this.doctorProfileRepo});
  Future<Either<ApiErrorModel, void>> call() async {
    return await doctorProfileRepo.deleteImage();
  }
}
