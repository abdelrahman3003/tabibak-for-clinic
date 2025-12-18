import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/repos/doctor_profile_repo.dart';

class UpdateDoctorInfoUseCase {
  final DoctorProfileRepo doctorProfileRepo;

  UpdateDoctorInfoUseCase({required this.doctorProfileRepo});
  Future<Either<ApiErrorModel, void>> call(
      {String? name, String? phone, String? address, String? bio}) async {
    return doctorProfileRepo.updateDoctorInfo(
        name: name, address: address, bio: bio, phone: phone);
  }
}
