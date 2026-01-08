import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_handler.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/appointment/data/data_source/appointment_remote_data.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_home_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/repos/appointment_repos.dart';

class AppointmentRepoImpl extends AppointmentRepo {
  final AppointmentRemoteData appointmentRemoteData;

  AppointmentRepoImpl({required this.appointmentRemoteData});

  @override
  Future<Either<ApiErrorModel, AppointmentHomeEntity>>
      getAppointmentHome() async {
    try {
      final response = await appointmentRemoteData.getAppointmentHome();
      return right(response);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, List<AppointmentEntity>>>
      updateAppointmentStatus(
          {required int statusIndex,
          required int appointmentId,
          bool isToday = false,
          required int type}) async {
    try {
      final response = await appointmentRemoteData.updateAppointmentStatus(
          statusIndex: statusIndex,
          appointmentId: appointmentId,
          type: type,
          isToday: isToday);

      return right(response);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, List<AppointmentEntity>>>
      getCanceledAppointments() async {
    try {
      final response = await appointmentRemoteData.getUpcomingAppointments();
      return right(response);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, List<AppointmentEntity>>>
      getFinishedAppointments() async {
    try {
      final response = await appointmentRemoteData.getFinishedAppointments();
      return right(response);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, List<AppointmentEntity>>>
      getUpcomingAppointments() async {
    try {
      final response = await appointmentRemoteData.getCanceledAppointments();
      return right(response);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }
}
