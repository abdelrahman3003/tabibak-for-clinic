import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_handler.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/auth/data/data_source/auth_remote_data.dart';
import 'package:tabibak_for_clinic/feature/auth/data/models/dotcor_model.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/doctor_entity.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/specialty_entity.dart';
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
  Future<Either<ApiErrorModel, int>> signUp(
      {required DoctorEntity doctorEntity, required String password}) async {
    final dotcorModel = DotcorModel(
        name: doctorEntity.name,
        email: doctorEntity.email,
        phone: doctorEntity.phone,
        image: doctorEntity.image,
        specialty: doctorEntity.specialty,
        medicalLiecense: doctorEntity.medicalLiecense,
        password: password);
    try {
      await authRemoteData.signUp(
          email: doctorEntity.email, password: password);
      await authRemoteData.uploadFile(doctorEntity.medicalLiecense);
      final result = await authRemoteData.addDoctor(dotcorModel: dotcorModel);
      return right(result);
    } catch (e) {
      log("--------------88888888888$e");

      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, List<SpecialtyEntity>>> getSpecialties() async {
    try {
      final result = await authRemoteData.getSpecialties();
      return right(result);
    } on Exception catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }
}
