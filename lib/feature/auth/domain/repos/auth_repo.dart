import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/specialty_entity.dart';

abstract class AuthRepo {
  Future<Either<ApiErrorModel, void>> signUp(
      {required DoctorEntity doctorEntity});
  Future<Either<ApiErrorModel, void>> uploadFile({required String filePath});
  Future<Either<ApiErrorModel, DoctorEntity?>> signIn(
      {required String email, required String password});
  Future<Either<ApiErrorModel, void>> sendOtp(String email);
  Future<Either<ApiErrorModel, void>> resetPassword(String newPassword);
  Future<Either<ApiErrorModel, void>> verifyOtp(
      {required String email, required String otp});
  Future<Either<ApiErrorModel, DoctorEntity?>> signInWithGoogle();
  Future<Either<ApiErrorModel, List<SpecialtyEntity>>> getSpecialties();
  Future<Either<ApiErrorModel, void>> addDoctor(
      {required DoctorEntity doctorEntity});
}
