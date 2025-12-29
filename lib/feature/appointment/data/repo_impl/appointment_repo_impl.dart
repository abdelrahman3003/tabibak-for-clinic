import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_handler.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/appointment/data/data_source/appointment_remote_data.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/repos/appointment_repos.dart';

class AppointmentRepoImpl extends AppointmentRepo {
  final AppointmentRemoteData appointmentRemoteData;

  AppointmentRepoImpl({required this.appointmentRemoteData});
  @override
  Future<Either<ApiErrorModel, List<AppointmentEntity>>>
      getAppointments() async {
    try {
      final response = await appointmentRemoteData.getAppointments();
      return right(response);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }
}
