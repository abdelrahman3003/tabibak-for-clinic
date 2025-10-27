import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/repos/auth_repo.dart';

class SignInWithGooglUsecase {
  final AuthRepo authRepo;

  SignInWithGooglUsecase({required this.authRepo});
  Future<Either<ApiErrorModel, void>> call() async {
    return await authRepo.signInWithGoogle();
  }
}
