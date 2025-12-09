import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_day_with_time_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/repos/clinic_repo.dart';

class CreateClinicWorkingDayShiftUseCase {
  final ClinicRepo clinicRepo;

  CreateClinicWorkingDayShiftUseCase({required this.clinicRepo});
  Future<Either<ApiErrorModel, void>> call({
    required int clinicId,
    required List<ClinicDayWithTimes> days,
  }) async {
    final result = await clinicRepo.addWorkingDayWithShifts(
        days: days, clinicId: clinicId);
    return result;
  }
}
