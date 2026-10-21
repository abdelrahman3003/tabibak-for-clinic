import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/doctor_service_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/repos/clinic_repo.dart';

class SaveDoctorServiceUseCase {
  final ClinicRepo clinicRepo;

  SaveDoctorServiceUseCase({required this.clinicRepo});

  Future<Either<ApiErrorModel, DoctorServiceEntity>> call(
      {required DoctorServiceEntity serviceEntity}) async {
    return await clinicRepo.saveDoctorService(serviceEntity: serviceEntity);
  }
}
