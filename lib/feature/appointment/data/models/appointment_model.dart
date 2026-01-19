import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    super.appointmentId,
    super.appointmentDate,
    super.status,
    super.statusId,
    super.doctorId,
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
      userImage: json['users']?['image'],
      status: json['appointments_status']['status'],
      phone: json['phone'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "doctor_id": doctorId,
      "user_id": userId,
      'name': name,
      'appointment_date': appointmentDate?.toIso8601String(),
      'status': statusId,
      'appointment_shift': appointmentShift,
      'phone': phone,
      'description': description,
    };
  }

  factory AppointmentModel.fromEntity(AppointmentEntity entity) {
    return AppointmentModel(
      name: entity.name,
      doctorId: entity.doctorId,
      userId: entity.userId,
      statusId: entity.statusId,
      appointmentDate: entity.appointmentDate,
      appointmentShift: entity.appointmentShift,
      phone: entity.phone,
      description: entity.description,
    );
  }
}
