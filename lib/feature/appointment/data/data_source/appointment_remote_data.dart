import 'package:tabibak_for_clinic/feature/appointment/data/models/appointment_model.dart';

abstract class AppointmentRemoteData {
  Future<List<AppointmentModel>> getAppointments();
}
