import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/repos/appointment_repos.dart';

class GetAppointmentDetailsUseCase {
  final AppointmentRepo appointmentRepos;

  GetAppointmentDetailsUseCase({required this.appointmentRepos});

  Future<Either<ApiErrorModel, AppointmentEntity?>> call(
      int appointmentId) async {
    final result = await appointmentRepos.getAppointmentDetails(appointmentId);

    return result;
  }
}
