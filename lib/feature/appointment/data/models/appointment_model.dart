import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    super.appointmentId,
    required super.appointmentDate,
    required super.status,
    required super.userName,
    required super.userImage,
    super.appointmentShift,
    super.phone,
    super.name,
    super.description,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      appointmentId: json['id'],
      appointmentDate: DateTime.parse(json['appointment_date']),
      status: json['appointments_status']['status'],
      userName: json['users']['name'],
      userImage: json['users']['image'],
      appointmentShift: json['shift'],
      phone: json['users']['phone'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointment_date': appointmentDate?.toIso8601String().split('T').first,
    };
  }

  factory AppointmentModel.fromEntity(AppointmentEntity entity) {
    return AppointmentModel(
      appointmentId: entity.appointmentId,
      appointmentDate: entity.appointmentDate,
      status: entity.status,
      userName: entity.userName,
      userImage: entity.userImage,
      appointmentShift: entity.appointmentShift,
      phone: entity.phone,
      name: entity.name,
      description: entity.description,
    );
  }
}
