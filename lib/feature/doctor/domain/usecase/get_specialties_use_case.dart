import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/specialty_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/repos/doctor_profile_repo.dart';

class GetSpecialtiesUseCase {
  final DoctorProfileRepo doctorProfileRepo;

  GetSpecialtiesUseCase({required this.doctorProfileRepo});

  Future<Either<ApiErrorModel, List<SpecialtyEntity>>> call() async {
    return await doctorProfileRepo.getSpecialties();
  }
}
