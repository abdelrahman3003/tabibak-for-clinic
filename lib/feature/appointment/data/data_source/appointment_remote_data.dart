import 'package:tabibak_for_clinic/feature/appointment/data/models/appointment_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_shift_model.dart';

abstract class AppointmentRemoteData {
  Future<List<AppointmentModel>> getAppointments({int? type, bool? isToday});
  Future<void> updateAppointmentStatus(
      {required int statusIndex, required int appointmentId});
  Future<void> addAppointment(AppointmentModel appointment);
  Future<AppointmentModel> getAppointmentDetails(int appointmentId);
  Future<ClinicShiftModel?> getAppointmentShift(String dayEn);
}
