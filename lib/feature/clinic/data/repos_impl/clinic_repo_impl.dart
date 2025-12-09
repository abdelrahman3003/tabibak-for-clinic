import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_handler.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/data_source/clinic_remote_data.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_day_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_info_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_time_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_day_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_time_entity.dart';
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
  Future<Either<ApiErrorModel, List<ClinicDayEntity>>> getAllDays() async {
    try {
      final models = await clinicRemoteData.getAllDays();
      final entities = models.map((e) => e.toEntity()).toList();
      return right(entities);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, void>> addWorkingDayWithShifts(
      {required int dayId,
      required ClinicTimeEntity morningTime,
      required ClinicTimeEntity eveningTime,
      required int clinicId}) async {
    try {
      final morningTimeModel = morningTime.toModel();
      final eveningTimeModel = eveningTime.toModel();

      await clinicRemoteData.addWorkingDayWithShifts(
          dayId: dayId,
          morningTimeModel: morningTimeModel,
          eveningTimeModel: eveningTimeModel,
          clinicId: clinicId);
      return right(null);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }
}
