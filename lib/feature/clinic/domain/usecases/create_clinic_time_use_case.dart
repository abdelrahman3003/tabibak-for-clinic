import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_time_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/repos/clinic_repo.dart';

class CreateClinicTimeUseCase {
  final ClinicRepo clinicRepo;

  CreateClinicTimeUseCase({required this.clinicRepo});
  Future<Either<ApiErrorModel, int>> call(
      ClinicTimeEntity clinicShiftEntity) async {
    final result = await clinicRepo.createClinicTime(clinicShiftEntity);
    return result;
  }
}
