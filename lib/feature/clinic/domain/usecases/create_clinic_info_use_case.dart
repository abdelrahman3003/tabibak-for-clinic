import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/repos/clinic_repo.dart';

class CreateClinicInfoUseCase {
  final ClinicRepo clinicRepo;

  CreateClinicInfoUseCase({required this.clinicRepo});
  Future<Either<ApiErrorModel, int>> call(
      ClinicInfoEntity clinicInfoEntity) async {
    final result = await clinicRepo.createClinicInfo(clinicInfoEntity);
    return result;
  }
}
