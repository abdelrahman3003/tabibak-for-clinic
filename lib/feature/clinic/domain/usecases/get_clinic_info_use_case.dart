import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/repos/clinic_repo.dart';

class GetClinicInfoUseCase {
  final ClinicRepo clinicRepo;

  GetClinicInfoUseCase({required this.clinicRepo});
  Future<Either<ApiErrorModel, List<ClinicInfoEntity>>> call() async {
    final result = await clinicRepo.getClinicInfo();
    return result;
  }
}
