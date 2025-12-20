import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/education_entity.dart';

abstract class DoctorProfileRepo {
  Future<Either<ApiErrorModel, DoctorEntity>> getDoctor();
  Future<Either<ApiErrorModel, void>> uploadImage(String imagePath);
  Future<Either<ApiErrorModel, void>> updateDoctorInfo(
      {String? name, String? phone, String? address, String? bio});
  Future<Either<ApiErrorModel, void>> updateEducation(
      {EducationEntity? educationEntity, XFile? file});
}
