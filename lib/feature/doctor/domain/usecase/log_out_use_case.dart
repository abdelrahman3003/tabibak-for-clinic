import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/helper/shared_pref_helper.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/repos/doctor_profile_repo.dart';

class LogOutUseCase {
  final DoctorProfileRepo doctorProfileRepo;

  LogOutUseCase({required this.doctorProfileRepo});

  Future<Either<ApiErrorModel, void>> call() async {
    final result = await doctorProfileRepo.logOut();
    return result.fold(
      (error) {
        return Left(error);
      },
      (_) {
        getit<SharedPrefHelper>().removeData(SharedPrefKeys.step);
        return const Right(null);
      },
    );
  }
}
