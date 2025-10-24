import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/clinic_day_shift.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/clinic_entity.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/doctor_entity.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/university_entity.dart';

abstract class DoctorRepo {
  // Future<Either<ApiErrorModel, int>> addTime(TimeEntity timeEntity);
  // Future<Either<ApiErrorModel, int>> addShift(ShiftEntity shiftEntity,
  //     {required int workdayId});
  // Future<Either<ApiErrorModel, int>> addWorkDay(WorkDayEntity workDayEntity,
  //     {required int clinicId});
  // Future<Either<ApiErrorModel, int>> addClinic(ClinicEntity clinicEntity,
  //     {required int doctorId});
  // Future<Either<ApiErrorModel, int>> addUniversity(
  //     UniversityEntity universityEntity,
  //     {required int doctorId});
  // Future<Either<ApiErrorModel, int>> addDoctor(DoctorEntity doctorEntity);
  Future<Either<ApiErrorModel, void>> addDoctorData({
    required DoctorEntity doctorEntity,
    required ClinicEntity clinicEntity,
    required UniversityEntity universityEntity,
    required List<WorkDayShift> workDayShifts,
  });
}
