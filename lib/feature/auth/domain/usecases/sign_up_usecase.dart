import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/helper/shared_pref_helper.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/doctor_entity.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/repos/auth_repo.dart';

class SignUpUsecase {
  final AuthRepo authRepo;

  SignUpUsecase({required this.authRepo});
  Future<Either<ApiErrorModel, void>> call(
      {required DoctorEntity doctorEntity,
      required String password,
      required User? user}) async {
    if (user == null) {
      final signUpResult =
          await authRepo.signUp(doctorEntity: doctorEntity, password: password);
      if (signUpResult.isLeft()) return signUpResult;
    }
    final uploadResult =
        await authRepo.uploadFile(filePath: doctorEntity.medicalLiecense);
    if (uploadResult.isLeft()) return uploadResult;
    final addDoctorResult = await authRepo.addDoctor(
        doctorEntity: doctorEntity, password: password);
    addDoctorResult.fold(
      (_) {},
      (_) {
        getit<SharedPrefHelper>().setData(key: SharedPrefKeys.step, value: 2);
      },
    );
    return addDoctorResult;
  }
}
