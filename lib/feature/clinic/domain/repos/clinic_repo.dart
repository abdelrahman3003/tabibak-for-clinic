import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_working_day_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_address_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_day_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_working_day_entity.dart';

abstract class ClinicRepo {
  Future<Either<ApiErrorModel, List<ClinicInfoEntity>>> getClinicInfo();
  Future<Either<ApiErrorModel, int>> createClinicInfo(
      {required ClinicInfoEntity clinicInfoEntity});

  Future<Either<ApiErrorModel, void>> saveClinicWorkingDays({
    required int clinicId,
    required List<ClinicWorkingDayModel> days,
  });
  Future<Either<ApiErrorModel, List<ClinicDayEntity>>> getAllDays();
  Future<Either<ApiErrorModel, List<ClinicWorkingDayEntity>>> getClinicSchedule(
      {required int clinicId});
  Future<Either<ApiErrorModel, void>> saveClinicInfo({
    required ClinicInfoEntity clinicInfoEntity,
  });
  Future<Either<ApiErrorModel, void>> saveClinicAddress({
    required ClinicAddressEntity clinicAddressEntity,
  });
}
