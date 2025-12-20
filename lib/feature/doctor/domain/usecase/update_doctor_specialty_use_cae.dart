import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/repos/doctor_profile_repo.dart';

class UpdateDoctorSpecialtyUseCae {
  final DoctorProfileRepo doctorProfileRepo;

  UpdateDoctorSpecialtyUseCae({required this.doctorProfileRepo});

  Future<Either<ApiErrorModel, void>> call({required int specialtyId}) async {
    return await doctorProfileRepo.updateSpecialty(specialtyId: specialtyId);
  }
}
