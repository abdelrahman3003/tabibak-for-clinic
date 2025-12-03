import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_handler.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/data_source/clinic_remote_data.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_info_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_shift_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_time_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_working_day_model.dart';
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
    final clinicInfoModel = ClinicInfoModel(
      clinicName: clinicInfoEntity.clinicName,
      address: clinicInfoEntity.address,
      phoneNumber: clinicInfoEntity.phoneNumber,
      consultationFee: clinicInfoEntity.consultationFee,
      isBooking: clinicInfoEntity.isBooking,
      doctorId: clinicInfoEntity.doctorId,
    );
    try {
      final result = await clinicRemoteData.createClinicInfo(clinicInfoModel);
      return right(result);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, int>> createClinicWorkingDay(
      ClinicWorkingDayEntity clinicWorkingDayEntity) async {
    final model = ClinicWorkingDayModel(
        clinicId: clinicWorkingDayEntity.clinicId,
        day: clinicWorkingDayEntity.day);
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
    final model = ClinicShiftModel(
        morning: clinicShiftEntity.morning,
        evening: clinicShiftEntity.evening,
        workingDayId: clinicShiftEntity.workingDayId);
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
    final model = ClinicTimeModel(
        start: clinicTimeEntity.start, end: clinicTimeEntity.end);
    try {
      final result = await clinicRemoteData.createClinicTime(model);
      return right(result);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }
}
