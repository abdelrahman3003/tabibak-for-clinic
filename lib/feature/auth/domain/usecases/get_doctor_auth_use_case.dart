import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/repos/auth_repo.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart';

class GetDoctorAuthUseCase {
  final AuthRepo authRepo;

  GetDoctorAuthUseCase({required this.authRepo});
  Future<Either<ApiErrorModel, DoctorEntity?>> call(
      {required User user}) async {
    final result = await authRepo.getDoctor(user: user);
    return result;
  }
}
