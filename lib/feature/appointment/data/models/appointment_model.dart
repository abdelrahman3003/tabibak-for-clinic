import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  const AppointmentModel(
      {super.appointmentId,
      super.appointmentDate,
      super.statusEn,
      super.statusAr,
      super.statusId,
      super.doctorId,
      super.userId,
      super.userImage,
      super.appointmentShift,
      super.phone,
      super.name,
      super.description,
      super.appointmentTypeEn,
      super.appointmentTypeAr});

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
        appointmentId: json['id'],
        appointmentDate: DateTime.parse(json['appointment_date']),
        userImage: json['users']?['image'],
        statusAr: json['appointments_status']['status_ar'],
        statusEn: json['appointments_status']['status_en'],
        statusId: json['appointments_status']['id'],
        phone: json['phone'],
        name: json['name'],
        description: json['description'],
        doctorId: json['doctor_id'].toString(),
        userId: json['user_id'].toString(),
        appointmentShift: json['appointment_shift'],
        appointmentTypeEn: json['appointment_types']?['appointment_type_en'],
        appointmentTypeAr: json['appointment_types']?['appointment_type_ar']);
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
      appointmentTypeEn: entity.appointmentTypeEn,
      appointmentTypeAr: entity.appointmentTypeAr,
    );
  }
}
