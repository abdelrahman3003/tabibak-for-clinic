import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/repos/appointment_repos.dart';

class SetAppointmentFollowUpUseCase {
  final AppointmentRepo appointmentRepos;

  SetAppointmentFollowUpUseCase({required this.appointmentRepos});

  Future<Either<ApiErrorModel, void>> call(
      {required int appointmentId, required DateTime followUpDate}) async {
    final result = await appointmentRepos.setAppointmentFollowUp(
        appointmentId: appointmentId, followUpDate: followUpDate);

    return result;
  }
}
