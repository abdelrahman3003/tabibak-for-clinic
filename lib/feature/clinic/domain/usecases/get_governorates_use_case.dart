import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/governorate_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/repos/clinic_repo.dart';

class GetGovernoratesUseCase {
  final ClinicRepo clinicRepo;

  GetGovernoratesUseCase({required this.clinicRepo});
  Future<Either<ApiErrorModel, List<GovernorateEntity>>> call() async {
    final result = await clinicRepo.getGovernorates();
    return result;
  }
}
