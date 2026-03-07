import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/repos/auth_repo.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart';

class SignInUsecase {
  final AuthRepo authRepo;

  SignInUsecase({required this.authRepo});
  Future<Either<ApiErrorModel, DoctorEntity?>> call(
      String email, String password) async {
    final result = await authRepo.signIn(email: email, password: password);
    return result;
  }
}
