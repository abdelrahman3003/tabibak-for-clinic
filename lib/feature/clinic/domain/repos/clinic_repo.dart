import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_time_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_working_day_entity.dart';

abstract class ClinicRepo {
  Future<Either<ApiErrorModel, int>> createClinicInfo(
      ClinicInfoEntity clinicInfoEntity);
  Future<Either<ApiErrorModel, int>> createClinicWorkingDay(
      ClinicWorkingDayEntity clinicWorkingDayEntity);
  Future<Either<ApiErrorModel, int>> createClinicShift(
      ClinicShiftEntity clinicShiftEntity);
  Future<Either<ApiErrorModel, int>> createClinicTime(
      ClinicTimeEntity clinicTimeEntity);
}
