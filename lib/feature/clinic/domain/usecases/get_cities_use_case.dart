import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/city_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/repos/clinic_repo.dart';

class GetCitiesUseCase {
  final ClinicRepo clinicRepo;

  GetCitiesUseCase({required this.clinicRepo});
  Future<Either<ApiErrorModel, List<CityEntity>>> call() async {
    final result = await clinicRepo.getCities();
    return result;
  }
}
