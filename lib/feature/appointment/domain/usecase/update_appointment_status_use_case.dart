import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/repos/appointment_repos.dart';

class UpdateAppointmentStatusUseCase {
  final AppointmentRepo appointmentRepos;

  UpdateAppointmentStatusUseCase({required this.appointmentRepos});
  Future<Either<ApiErrorModel, List<AppointmentEntity>>> call(
      {required int statusIndex,
      required int appointmentId,
      bool isToday = false,
      required int type}) async {
    final result = await appointmentRepos.updateAppointmentStatus(
        statusIndex: statusIndex,
        appointmentId: appointmentId,
        type: type,
        isToday: isToday);
    return result;
  }
}
