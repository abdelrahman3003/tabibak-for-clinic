import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/repos/clinic_repo.dart';

class DeleteDoctorServiceUseCase {
  final ClinicRepo clinicRepo;

  DeleteDoctorServiceUseCase({required this.clinicRepo});

  Future<Either<ApiErrorModel, void>> call({required int serviceId}) async {
    return await clinicRepo.deleteDoctorService(serviceId: serviceId);
  }
}
