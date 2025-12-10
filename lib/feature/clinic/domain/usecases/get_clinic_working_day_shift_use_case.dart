import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_working_day_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/repos/clinic_repo.dart';

class GetClinicWorkingDayShiftUseCase {
  final ClinicRepo clinicRepo;

  GetClinicWorkingDayShiftUseCase({required this.clinicRepo});
  Future<Either<ApiErrorModel, List<ClinicWorkingDayEntity>>> call(
      int clinicId) async {
    final result = await clinicRepo.getClinicSchedule(clinicId: clinicId);
    return result;
  }
}
