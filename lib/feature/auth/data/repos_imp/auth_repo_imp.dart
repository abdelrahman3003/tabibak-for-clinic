import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_handler.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/auth/data/data_source/auth_remote_data.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/signin_result_entity.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/repos/auth_repo.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/model/dotcor_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/specialty_entity.dart';

class AuthRepoImp extends AuthRepo {
  final AuthRemoteData authRemoteData;
  AuthRepoImp({
    required this.authRemoteData,
  });
  @override
  Future<Either<ApiErrorModel, void>> signIn(
      {required String email, required String password}) async {
    try {
      final result = await authRemoteData.signIn(email, password);
      return right(result);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, void>> signUp(
      {required DoctorEntity doctorEntity}) async {
    try {
      final result = await authRemoteData.signUp(
          doctorModel: DoctorModel.fromEntity(doctorEntity));
      return right(result);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, List<SpecialtyEntity>>> getSpecialties() async {
    try {
      final result = await authRemoteData.getSpecialties();
      return right(result);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, SigninResultEntity>> signInWithGoogle() async {
    try {
      final result = await authRemoteData.signInWithGoogle();
      return right(result);
    } catch (e) {
      log("Error in signInWithGoogle: $e");
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, void>> uploadFile(
      {required String filePath}) async {
    try {
      final result = await authRemoteData.uploadFile(filePath);
      return right(result);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, void>> resetPassword(String newPassword) async {
    try {
      final result = await authRemoteData.resetPassword(newPassword);
      return right(result);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, void>> sendOtp(String email) async {
    log("-0------11");

    try {
      final result = await authRemoteData.sendOtp(email);
      return right(result);
    } catch (e) {
      log("-0------$e");
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, void>> verifyOtp(
      {required String email, required String otp}) async {
    try {
      final result = await authRemoteData.verifyOtp(email: email, otp: otp);
      return right(result);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }
}
