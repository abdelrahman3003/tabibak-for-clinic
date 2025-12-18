import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_handler.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/data_source/doctor_profile_remote_data.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart';
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
      final imageUrl = await doctorProfileRemoteData.updateDoctorInfo(
          name: name, phone: phone, address: address, bio: bio);

      return right(imageUrl);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }
}
