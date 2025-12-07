import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_handler.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/data_source/clinic_remote_data.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_day_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_info_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_shift_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_time_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_working_day_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_day_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_time_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_working_day_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/repos/clinic_repo.dart';

class ClinicRepoImpl implements ClinicRepo {
  final ClinicRemoteData clinicRemoteData;

  ClinicRepoImpl({required this.clinicRemoteData});
  @override
  Future<Either<ApiErrorModel, int>> createClinicInfo(
      ClinicInfoEntity clinicInfoEntity) async {
    final model = clinicInfoEntity.toModel();
    try {
      final result = await clinicRemoteData.createClinicInfo(model);
      return right(result);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, int>> createClinicWorkingDay(
      ClinicWorkingDayEntity clinicWorkingDayEntity) async {
    final model = clinicWorkingDayEntity.toModel();
    try {
      final result = await clinicRemoteData.createClinicWorkingDay(model);
      return right(result);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, int>> createClinicShift(
      ClinicShiftEntity clinicShiftEntity) async {
    final model = clinicShiftEntity.toModel();
    try {
      final result = await clinicRemoteData.createClinicShift(model);
      return right(result);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, int>> createClinicTime(
      ClinicTimeEntity clinicTimeEntity) async {
    final model = clinicTimeEntity.toModel();
    try {
      final result = await clinicRemoteData.createClinicTime(model);
      return right(result);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, List<ClinicDayEntity>>> getAllDays() async {
    try {
      final models = await clinicRemoteData.getAllDays();
      final entities = models.map((e) => e.toEntity()).toList();
      return right(entities);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }
}
