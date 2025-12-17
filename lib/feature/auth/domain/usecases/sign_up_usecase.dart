import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/helper/shared_pref_helper.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/repos/auth_repo.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart';

class SignUpUsecase {
  final AuthRepo authRepo;

  SignUpUsecase({required this.authRepo});
  Future<Either<ApiErrorModel, void>> call(
      {required DoctorEntity doctorEntity}) async {
    final signUpResult = await authRepo.signUp(doctorEntity: doctorEntity);
    // final uploadResult =
    //     await authRepo.uploadFile(filePath: doctorEntity.medicalLiecense);
    // if (uploadResult.isLeft()) return uploadResult;
    // final addDoctorResult =
    //     await authRepo.addDoctor(doctorEntity: doctorEntity);
    signUpResult.fold(
      (_) {},
      (_) {
        getit<SharedPrefHelper>().setData(key: SharedPrefKeys.step, value: 2);
      },
    );
    return signUpResult;
  }
}
