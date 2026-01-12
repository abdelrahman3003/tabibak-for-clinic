import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/repos/appointment_repos.dart';

class AddAppointmentUseCase {
  final AppointmentRepo appointmentRepos;

  AddAppointmentUseCase({required this.appointmentRepos});

  Future<Either<ApiErrorModel, void>> call(
      AppointmentEntity appointment) async {
    final result = await appointmentRepos.addAppointment(appointment);
    return result;
  }
}
