import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';

abstract class AuthRepo {
  Future<Either<ApiErrorModel, void>> signUp(
      {required String email, required String password});
  Future<Either<ApiErrorModel, void>> signIn(
      {required String email, required String password});
}
