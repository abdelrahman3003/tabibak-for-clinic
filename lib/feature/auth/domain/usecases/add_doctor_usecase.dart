import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/clinic_day_shift.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/clinic_entity.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/doctor_entity.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/university_entity.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/repos/doctor_repo.dart';

class DoctorUsecase {
  final DoctorRepo doctorRepo;

  DoctorUsecase({required this.doctorRepo});
  Future<Either<ApiErrorModel, void>> call({
    required DoctorEntity doctorEntity,
    required ClinicEntity clinicEntity,
    required UniversityEntity universityEntity,
    required List<WorkDayShift> workDayShifts,
  }) {
    return doctorRepo.addDoctorData(
      doctorEntity: doctorEntity,
      clinicEntity: clinicEntity,
      universityEntity: universityEntity,
      workDayShifts: workDayShifts,
    );
  }
}
