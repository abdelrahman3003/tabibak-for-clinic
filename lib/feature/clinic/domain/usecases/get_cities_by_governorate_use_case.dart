import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/city_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/repos/clinic_repo.dart';

class GetCitiesByGovernorateUseCase {
  final ClinicRepo clinicRepo;

  GetCitiesByGovernorateUseCase({required this.clinicRepo});
  Future<Either<ApiErrorModel, List<CityEntity>>> call(
      int governorateId) async {
    final result = await clinicRepo.getCitiesByGovernorate(
        governorateId: governorateId);
    return result;
  }
}
