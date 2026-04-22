import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_handler.dart';
import 'package:tabibak_for_clinic/core/networking/api_error_model.dart';
import 'package:tabibak_for_clinic/feature/appointment/data/data_source/appointment_remote_data.dart';
import 'package:tabibak_for_clinic/feature/appointment/data/models/appointment_model.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/repos/appointment_repos.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_entity.dart';

class AppointmentRepoImpl extends AppointmentRepo {
  final AppointmentRemoteData appointmentRemoteData;

  AppointmentRepoImpl({required this.appointmentRemoteData});

  @override
  Future<Either<ApiErrorModel, List<AppointmentEntity>>> getAppointments(
      {int? type, bool? isToday}) async {
    try {
      final response = await appointmentRemoteData.getAppointments(
          isToday: isToday, type: type);
      return right(response);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, void>> addAppointment(
      AppointmentEntity appointment) async {
    try {
      final response = await appointmentRemoteData
          .addAppointment(AppointmentModel.fromEntity(appointment));
      return right(response);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, ClinicShiftEntity?>> getAppointmentShift(
      String dayEn) async {
    try {
      final response = await appointmentRemoteData.getAppointmentShift(dayEn);
      return right(response);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, void>> updateAppointmentStatus(
      {required int statusIndex, required int appointmentId}) async {
    try {
      final response = await appointmentRemoteData.updateAppointmentStatus(
        statusIndex: statusIndex,
        appointmentId: appointmentId,
      );
      return right(response);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<ApiErrorModel, AppointmentEntity?>> getAppointmentDetails(
      int appointmentId) async {
    try {
      final response =
          await appointmentRemoteData.getAppointmentDetails(appointmentId);
      return right(response);
    } catch (e) {
      log("--------_$e");
      return left(ErrorHandler.handle(e));
    }
  }
}
