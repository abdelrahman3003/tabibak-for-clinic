import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/repos/auth_repo.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/specialty_entity.dart';

class GetSpecialtiesUsecase {
  final AuthRepo authRepo;

  GetSpecialtiesUsecase({required this.authRepo});
  Future<Either<ApiErrorModel, List<SpecialtyEntity>>> call() async {
    return await authRepo.getSpecialties();
  }
}
