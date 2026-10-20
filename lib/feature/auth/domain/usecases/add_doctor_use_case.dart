import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/helper/shared_pref_helper.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/repos/auth_repo.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart';

class AddDoctorUseCase {
  final AuthRepo authRepo;

  AddDoctorUseCase({required this.authRepo});
  Future<Either<ApiErrorModel, void>> call(DoctorEntity doctorEntity) async {
    log("AddDoctorUseCase called with doctorEntity: ${doctorEntity.toString()}");
    final result = await authRepo.addDoctor(doctorEntity: doctorEntity);
    result.fold(
      (_) {},
      (_) {
        getit<SharedPrefHelper>().setData(key: SharedPrefKeys.step, value: 2);
      },
    );
    return result;
  }
}
