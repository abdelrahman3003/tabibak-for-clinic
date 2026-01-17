import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/repos/appointment_repos.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_entity.dart';

class GetAppointmentShiftUseCase {
  final AppointmentRepo appointmentRepos;

  GetAppointmentShiftUseCase({required this.appointmentRepos});

  Future<Either<ApiErrorModel, ClinicShiftEntity?>> call(String dayEn) async {
    final result = await appointmentRepos.getAppointmentShift(dayEn);

    return result;
  }
}
