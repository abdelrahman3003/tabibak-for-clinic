import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/signin_result_entity.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/repos/auth_repo.dart';

class SignInWithGooglUsecase {
  final AuthRepo authRepo;

  SignInWithGooglUsecase({required this.authRepo});
  Future<Either<ApiErrorModel, SigninResultEntity>> call() async {
    final result = await authRepo.signInWithGoogle();
    return result;
  }
}
