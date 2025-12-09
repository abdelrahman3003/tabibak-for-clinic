import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_time_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/repos/clinic_repo.dart';

class CreateClinicWorkingDayShiftUseCase {
  final ClinicRepo clinicRepo;

  CreateClinicWorkingDayShiftUseCase({required this.clinicRepo});
  Future<Either<ApiErrorModel, void>> call(
      {required int dayId,
      required ClinicTimeEntity morningTime,
      required ClinicTimeEntity eveningTime,
      required int clinicId}) async {
    final result = await clinicRepo.addWorkingDayWithShifts(
        dayId: dayId,
        morningTime: morningTime,
        eveningTime: eveningTime,
        clinicId: clinicId);
    return result;
  }
}
