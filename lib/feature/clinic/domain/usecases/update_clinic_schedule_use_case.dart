import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_day_with_time_edit.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/repos/clinic_repo.dart';

class UpdateClinicScheduleUseCase {
  final ClinicRepo clinicRepo;

  UpdateClinicScheduleUseCase({required this.clinicRepo});
  Future<Either<ApiErrorModel, void>> call(
    int clinicId,
    List<ClinicDayWithTimeEdit> days,
  ) async {
    final result = await clinicRepo.updateWorkingDaysWithShifts(
        clinicId: clinicId, days: days);
    return result;
  }
}
