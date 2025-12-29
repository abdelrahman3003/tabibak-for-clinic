import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    required super.appointmentTime,
    required super.appointmentDate,
    required super.status,
    required super.userName,
    required super.userImage,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      appointmentTime: json['appointment_time'],
      appointmentDate: DateTime.parse(json['appointment_date']),
      status: json['appointments_status']['status'],
      userName: json['users']['name'],
      userImage: json['users']['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointment_time': appointmentTime,
      'appointment_date': appointmentDate?.toIso8601String().split('T').first,
    };
  }
}
