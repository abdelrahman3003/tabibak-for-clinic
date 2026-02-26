import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/repos/auth_repo.dart';

class VerifiedCodeUseCase {
  final AuthRepo authRepo;

  VerifiedCodeUseCase({required this.authRepo});
  Future<Either<ApiErrorModel, void>> call(
      {required String email, required String otp}) async {
    final result = await authRepo.verifyOtp(email: email, otp: otp);
    return result;
  }
}
