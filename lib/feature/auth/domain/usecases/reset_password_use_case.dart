import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/repos/auth_repo.dart';

class ResetPasswordUseCase {
  final AuthRepo authRepo;

  ResetPasswordUseCase({required this.authRepo});
  Future<Either<ApiErrorModel, void>> call(String newPassword) async {
    final result = await authRepo.resetPassword(newPassword);
    return result;
  }
}
