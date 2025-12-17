import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/repos/doctor_profile_repo.dart';

class GetDoctorUseCase {
  final DoctorProfileRepo doctorProfileRepo;

  GetDoctorUseCase({required this.doctorProfileRepo});

  Future<Either<ApiErrorModel, DoctorEntity>> call() async {
    return await doctorProfileRepo.getDoctor();
  }
}
