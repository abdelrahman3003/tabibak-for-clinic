import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/specialty_entity.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/repos/auth_repo.dart';

class GetSpecialtiesUsecase {
  final AuthRepo authRepo;

  GetSpecialtiesUsecase({required this.authRepo});
  Future<Either<ApiErrorModel, List<SpecialtyEntity>>> call() async {
    return await authRepo.getSpecialties();
  }
}
