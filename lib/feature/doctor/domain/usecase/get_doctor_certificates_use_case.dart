import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_file_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/repos/doctor_profile_repo.dart';

class GetDoctorCertificatesUseCase {
  final DoctorProfileRepo doctorProfileRepo;

  GetDoctorCertificatesUseCase({required this.doctorProfileRepo});

  Future<Either<ApiErrorModel, List<DoctorFileEntity>>> call() async {
    return await doctorProfileRepo.getCertificates();
  }
}
