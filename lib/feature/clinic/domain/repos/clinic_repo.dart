import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_day_with_time_edit.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_day_with_time_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_day_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_working_day_entity.dart';

abstract class ClinicRepo {
  Future<Either<ApiErrorModel, List<ClinicInfoEntity>>> getClinicInfo();
  Future<Either<ApiErrorModel, int>> createClinicInfo(
      {required ClinicInfoEntity clinicInfoEntity});
  Future<Either<ApiErrorModel, void>> addWorkingDayWithShifts({
    required int clinicId,
    required List<ClinicDayWithTimesModel> days,
  });
  Future<Either<ApiErrorModel, void>> updateWorkingDaysWithShifts({
    required int clinicId,
    required List<ClinicDayWithTimeEdit> days,
  });
  Future<Either<ApiErrorModel, List<ClinicDayEntity>>> getAllDays();
  Future<Either<ApiErrorModel, List<ClinicWorkingDayEntity>>> getClinicSchedule(
      {required int clinicId});
  Future<Either<ApiErrorModel, void>> saveClinicInfo({
    required ClinicInfoEntity clinicInfoEntity,
  });
}
