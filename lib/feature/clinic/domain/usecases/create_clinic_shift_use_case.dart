import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/repos/clinic_repo.dart';

class CreateClinicShiftUseCase {
  final ClinicRepo clinicRepo;

  CreateClinicShiftUseCase({required this.clinicRepo});
  Future<Either<ApiErrorModel, int>> call(
      ClinicShiftEntity clinicShiftEntity) async {
    final result = await clinicRepo.createClinicShift(clinicShiftEntity);
    return result;
  }
}
