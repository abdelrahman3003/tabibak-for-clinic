import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_handler.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/data_source/doctor_profile_remote_data.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/model/education_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/education_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/specialty_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/repos/doctor_profile_repo.dart';

class DoctorProfileRepoImp implements DoctorProfileRepo {
  final DoctorProfileRemoteData doctorProfileRemoteData;

  DoctorProfileRepoImp({required this.doctorProfileRemoteData});
  @override
  Future<Either<ApiErrorModel, DoctorEntity>> getDoctor() async {
    try {
      final doctorModel = await doctorProfileRemoteData.getDoctor();
      if (doctorModel == null) {
        return left(ApiErrorModel(message: "Doctor not found"));
      }
      return right(doctorModel);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, void>> uploadImage(String imagePath) async {
    try {
      final imageUrl = await doctorProfileRemoteData.uploadImage(imagePath);

      return right(imageUrl);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, void>> updateDoctorInfo(
      {String? name, String? phone, String? address, String? bio}) async {
    try {
      final result = await doctorProfileRemoteData.updateDoctorInfo(
          name: name, phone: phone, address: address, bio: bio);

      return right(result);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, void>> updateEducation(
      {EducationEntity? educationEntity, XFile? file}) async {
    try {
      final educationModel = EducationModel.toModel(educationEntity!);
      final result = await doctorProfileRemoteData.updateEducation(
          educationModel: educationModel, file: file);
      return right(result);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, List<SpecialtyEntity>>> getSpecialties() async {
    try {
      final specialties = await doctorProfileRemoteData.getSpecialties();

      return right(specialties);
    } catch (e) {
      log("===== upd sp$e");

      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, void>> updateSpecialty(
      {required int specialtyId}) async {
    try {
      final result = await doctorProfileRemoteData.updateSpecialty(
          specialtyId: specialtyId);
      return right(result);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, void>> logOut() async {
    try {
      final result = await doctorProfileRemoteData.logOut();
      return right(result);
    } catch (e) {
      log("===== get sp$e");
      return left(ErrorHandler.handle(e));
    }
  }
}
