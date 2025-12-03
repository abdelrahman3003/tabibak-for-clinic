import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_handler.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/data_source/clinic_remote_data.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_info_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
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
}
