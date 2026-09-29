import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/repos/appointment_repos.dart';

class PostponeAppointmentUseCase {
  final AppointmentRepo appointmentRepo;

  PostponeAppointmentUseCase({required this.appointmentRepo});

  Future<Either<ApiErrorModel, void>> call({
    required int appointmentId,
    required int positions,
  }) async {
    return await appointmentRepo.postponeAppointment(
      appointmentId: appointmentId,
      positions: positions,
    );
  }
}
