import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_working_day_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/repos/clinic_repo.dart';

class SaveClinicWorkingDayUseCase {
  final ClinicRepo clinicRepo;

  SaveClinicWorkingDayUseCase({required this.clinicRepo});
  Future<Either<ApiErrorModel, void>> call({
    required int clinicId,
    required List<ClinicWorkingDayModel> days,
  }) async {
    final result =
        await clinicRepo.saveClinicWorkingDays(clinicId: clinicId, days: days);
    return result;
  }
}
