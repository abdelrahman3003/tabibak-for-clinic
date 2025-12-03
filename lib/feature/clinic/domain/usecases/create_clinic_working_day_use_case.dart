import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_working_day_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/repos/clinic_repo.dart';

class CreateClinicWorkingDayUseCase {
  final ClinicRepo clinicRepo;

  CreateClinicWorkingDayUseCase({required this.clinicRepo});
  Future<Either<ApiErrorModel, int>> call(
      ClinicWorkingDayEntity clinicWorkingDayEntity) async {
    final result =
        await clinicRepo.createClinicWorkingDay(clinicWorkingDayEntity);
    return result;
  }
}
