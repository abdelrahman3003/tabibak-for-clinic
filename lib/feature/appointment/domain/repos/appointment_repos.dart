import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';

abstract class AppointmentRepo {
  Future<Either<ApiErrorModel, List<AppointmentEntity>>> getAppointments();
}
