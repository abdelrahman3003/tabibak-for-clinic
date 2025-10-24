import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/repos/auth_repo.dart';

class SignUpUsecase {
  final AuthRepo authRepo;

  SignUpUsecase({required this.authRepo});
  Future<Either<ApiErrorModel, void>> call(
      {required String email, required String password}) async {
    return await authRepo.signUp(email: email, password: password);
  }
}
