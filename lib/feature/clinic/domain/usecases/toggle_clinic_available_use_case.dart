import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/repos/clinic_repo.dart';

class ToggleClinicAvailableUseCase {
  final ClinicRepo clinicRepo;

  ToggleClinicAvailableUseCase({required this.clinicRepo});
  Future<Either<ApiErrorModel, void>> call(
      {required int clinicId, required bool isAvailable}) async {
    final result = await clinicRepo.toggleClinicAvailable(
        clinicId: clinicId, isAvailable: isAvailable);
    return result;
  }
}
