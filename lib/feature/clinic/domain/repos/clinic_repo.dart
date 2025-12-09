import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_day_with_time_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_day_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';

abstract class ClinicRepo {
  Future<Either<ApiErrorModel, List<ClinicInfoEntity>>> getClinicInfo();
  Future<Either<ApiErrorModel, int>> createClinicInfo(
      ClinicInfoEntity clinicInfoEntity);
  Future<Either<ApiErrorModel, void>> addWorkingDayWithShifts({
    required int clinicId,
    required List<ClinicDayWithTimes> days,
  });
  Future<Either<ApiErrorModel, List<ClinicDayEntity>>> getAllDays();
}
