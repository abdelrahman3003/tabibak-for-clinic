import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_status_entity.dart';

class AppointmentStatusModel extends AppointmentStatusEntity {
  const AppointmentStatusModel({required super.id, required super.status});
  factory AppointmentStatusModel.fromJson(Map<String, dynamic> json) {
    return AppointmentStatusModel(
      id: json['id'],
      status: json['status'],
    );
  }
}
