import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/repos/auth_repo.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart';

class AddDoctorUseCase {
  final AuthRepo authRepo;

  AddDoctorUseCase({required this.authRepo});
  Future<Either<ApiErrorModel, void>> call(DoctorEntity doctorEntity) async {
    final result = await authRepo.addDoctor(doctorEntity: doctorEntity);
    return result;
  }
}
