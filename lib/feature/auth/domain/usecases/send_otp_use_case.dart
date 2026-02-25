import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/repos/auth_repo.dart';

class SendOtpUseCase {
  final AuthRepo authRepo;

  SendOtpUseCase({required this.authRepo});
  Future<Either<ApiErrorModel, void>> call(String email) async {
    final result = await authRepo.sendOtp(email);
    return result;
  }
}
