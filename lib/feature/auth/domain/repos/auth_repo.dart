import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/doctor_entity.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/signin_result_entity.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/specialty_entity.dart';

abstract class AuthRepo {
  Future<Either<ApiErrorModel, void>> signUp(
      {required DoctorEntity doctorEntity});
  Future<Either<ApiErrorModel, String?>> uploadFile({required String filePath});
  Future<Either<ApiErrorModel, void>> signIn(
      {required String email, required String password});
  Future<Either<ApiErrorModel, SigninResultEntity>> signInWithGoogle();
  Future<Either<ApiErrorModel, List<SpecialtyEntity>>> getSpecialties();
}
