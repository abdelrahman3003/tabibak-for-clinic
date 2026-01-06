import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/repos/appointment_repos.dart';

class GetCanceledAppointmentsUseCase {
  final AppointmentRepo appointmentRepos;

  GetCanceledAppointmentsUseCase({required this.appointmentRepos});
  Future<Either<ApiErrorModel, List<AppointmentEntity>>> call() async {
    final result = await appointmentRepos.getCanceledAppointments();
    return result;
  }
}
