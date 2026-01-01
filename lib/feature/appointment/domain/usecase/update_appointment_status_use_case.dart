import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/repos/appointment_repos.dart';

class UpdateAppointmentStatusUseCase {
  final AppointmentRepo appointmentRepos;

  UpdateAppointmentStatusUseCase({required this.appointmentRepos});
  Future<Either<ApiErrorModel, List<AppointmentEntity>>> call(
      {required int statusIndex, required int appointmentId}) async {
    final result = await appointmentRepos.updateAppointmentStatus(
        statusIndex, appointmentId);
    return result;
  }
}
