import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/repos/auth_repo.dart';

class SignInUsecase {
  final AuthRepo authRepo;

  SignInUsecase({required this.authRepo});
  Future<Either<ApiErrorModel, void>> call(
      String email, String password) async {
    return await authRepo.signIn(email: email, password: password);
  }
}
