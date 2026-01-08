import 'package:tabibak_for_clinic/feature/appointment/data/models/appointment_model.dart';
import 'package:tabibak_for_clinic/feature/appointment/data/models/appointment_status_model.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_home_entity.dart';

abstract class AppointmentRemoteData {
  Future<List<AppointmentStatusModel>> getAppointmentStatus();
  Future<List<AppointmentModel>> getUpcomingAppointments();
  Future<List<AppointmentModel>> getFinishedAppointments();
  Future<List<AppointmentModel>> getCanceledAppointments();
  Future<AppointmentHomeEntity> getAppointmentHome();
  Future<List<AppointmentModel>> updateAppointmentStatus(
      {required int statusIndex,
      required int appointmentId,
      bool isToday = false,
      required int type});
}
