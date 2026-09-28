import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/city_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/repos/clinic_repo.dart';

class GetCitiesByParentUseCase {
  final ClinicRepo clinicRepo;

  GetCitiesByParentUseCase({required this.clinicRepo});
  Future<Either<ApiErrorModel, List<CityEntity>>> call(int parentId) async {
    final result = await clinicRepo.getCitiesByParent(parentId: parentId);
    return result;
  }
}
