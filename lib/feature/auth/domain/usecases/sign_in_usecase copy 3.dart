import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/helper/shared_pref_helper.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/repos/auth_repo.dart';

class SignInUsecase {
  final AuthRepo authRepo;

  SignInUsecase({required this.authRepo});
  Future<Either<ApiErrorModel, void>> call(
      String email, String password) async {
    final result = await authRepo.signIn(email: email, password: password);
    result.fold(
      (_) {},
      (_) {
        getit<SharedPrefHelper>().setData(key: SharedPrefKeys.step, value: 2);
      },
    );
    return result;
  }
}
