import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_day_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_time_entity.dart';

abstract class ClinicRepo {
  Future<Either<ApiErrorModel, int>> createClinicInfo(
      ClinicInfoEntity clinicInfoEntity);
  Future<Either<ApiErrorModel, void>> addWorkingDayWithShifts(
      {required int dayId,
      required ClinicTimeEntity morningTime,
      required ClinicTimeEntity eveningTime,
      required int clinicId});
  Future<Either<ApiErrorModel, List<ClinicDayEntity>>> getAllDays();
}
