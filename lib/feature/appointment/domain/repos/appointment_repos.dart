import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_entity.dart';

abstract class AppointmentRepo {
  Future<Either<ApiErrorModel, List<AppointmentEntity>>> getAppointments(
      {int? status, bool? isToday});
  Future<Either<ApiErrorModel, void>> addAppointment(
      AppointmentEntity appointment);
  Future<Either<ApiErrorModel, void>> updateAppointmentStatus(
      {required int statusIndex, required int appointmentId});
  Future<Either<ApiErrorModel, ClinicShiftEntity?>> getAppointmentShift(
      String dayEn);
  Future<Either<ApiErrorModel, AppointmentEntity?>> getAppointmentDetails(
      int appointmentId);
  Future<Either<ApiErrorModel, void>> setAppointmentFollowUp(
      {required int appointmentId, required DateTime followUpDate});
}
