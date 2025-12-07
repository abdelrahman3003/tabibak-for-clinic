import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_day_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/repos/clinic_repo.dart';

class GetDaysUseCase {
  final ClinicRepo clinicRepo;

  GetDaysUseCase({required this.clinicRepo});
  Future<Either<ApiErrorModel, List<ClinicDayEntity>>> call() async {
    final result = await clinicRepo.getAllDays();
    return result;
  }
}
