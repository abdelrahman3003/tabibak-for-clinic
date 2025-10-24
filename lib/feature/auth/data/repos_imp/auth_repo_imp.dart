import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_handler.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/auth/data/data_source/auth_remote_data.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/repos/auth_repo.dart';

class AuthRepoImp extends AuthRepo {
  final AuthRemoteData authRemoteData;
  AuthRepoImp({
    required this.authRemoteData,
  });
  @override
  Future<Either<ApiErrorModel, void>> signIn(
      {required String email, required String password}) async {
    try {
      final result = authRemoteData.signIn(email, password);
      return right(result);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, void>> signUp(
      {required String email, required String password}) async {
    try {
      final result = authRemoteData.signUp(email, password);
      return right(result);
    } on Exception catch (e) {
      return left(ErrorHandler.handle(e));
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }
}
