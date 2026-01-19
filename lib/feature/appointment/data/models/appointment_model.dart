import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    super.appointmentId,
    required super.appointmentDate,
    required super.status,
    super.userId,
    super.userImage,
    super.appointmentShift,
    super.phone,
    super.name,
    super.description,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      appointmentId: json['id'],
      appointmentDate: DateTime.parse(json['appointment_date']),
      userImage: json['users']['image'],
      status: json['appointments_status']['status'],
      phone: json['phone'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': appointmentId,
      "user_id": userId,
      'appointment_date': appointmentDate?.toIso8601String(),
      'status': status,
      'shift': appointmentShift,
      'phone': phone,
      'name': name,
      'description': description,
    };
  }

  factory AppointmentModel.fromEntity(AppointmentEntity entity) {
    return AppointmentModel(
      appointmentId: entity.appointmentId,
      appointmentDate: entity.appointmentDate,
      status: entity.status,
      userId: entity.userId,
      userImage: entity.userImage,
      appointmentShift: entity.appointmentShift,
      phone: entity.phone,
      name: entity.name,
      description: entity.description,
    );
  }
}
