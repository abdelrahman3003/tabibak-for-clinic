import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_address_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/repos/clinic_repo.dart';

class SaveClinicAddressUseCase {
  final ClinicRepo clinicRepo;

  SaveClinicAddressUseCase({required this.clinicRepo});
  Future<Either<ApiErrorModel, void>> call(
      ClinicAddressEntity clinicAddressEntity) async {
    final result = await clinicRepo.saveClinicAddress(
        clinicAddressEntity: clinicAddressEntity);
    return result;
  }
}
