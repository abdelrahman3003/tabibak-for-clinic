import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_home_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_entity.dart';

abstract class AppointmentRepo {
  Future<Either<ApiErrorModel, AppointmentHomeEntity>> getAppointmentHome();
  Future<Either<ApiErrorModel, List<AppointmentEntity>>>
      updateAppointmentStatus({
    required int statusIndex,
    required int appointmentId,
    bool isToday = false,
    required int type,
  });
  Future<Either<ApiErrorModel, List<AppointmentEntity>>>
      getUpcomingAppointments();
  Future<Either<ApiErrorModel, List<AppointmentEntity>>>
      getFinishedAppointments();
  Future<Either<ApiErrorModel, List<AppointmentEntity>>>
      getCanceledAppointments();
  Future<Either<ApiErrorModel, void>> addAppointment(
      AppointmentEntity appointment);
  Future<Either<ApiErrorModel, ClinicShiftEntity?>> getAppointmentShift(
      String dayEn);
}
