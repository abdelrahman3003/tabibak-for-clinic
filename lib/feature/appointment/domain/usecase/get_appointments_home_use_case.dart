import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_home_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/repos/appointment_repos.dart';

class GetAppointmentsUseCase {
  final AppointmentRepo appointmentRepos;

  GetAppointmentsUseCase({required this.appointmentRepos});
  Future<Either<ApiErrorModel, AppointmentHomeEntity>> call() async {
    final result = await appointmentRepos.getAppointmentHome();
    return result;
  }
}
