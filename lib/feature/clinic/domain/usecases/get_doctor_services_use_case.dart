import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/doctor_service_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/repos/clinic_repo.dart';

class GetDoctorServicesUseCase {
  final ClinicRepo clinicRepo;

  GetDoctorServicesUseCase({required this.clinicRepo});

  Future<Either<ApiErrorModel, List<DoctorServiceEntity>>> call(
      {required int clinicId}) async {
    return await clinicRepo.getDoctorServices(clinicId: clinicId);
  }
}
