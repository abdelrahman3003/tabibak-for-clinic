import 'package:equatable/equatable.dart';

class AppointmentEntity extends Equatable {
  final int? appointmentId;
  final DateTime? appointmentDate;
  final String? status;
  final String? userName;
  final String? userImage;
  final String? appointmentShift;
  final String? phone;
  final String? name;
  final String? description;

  const AppointmentEntity({
    this.appointmentId,
    this.appointmentDate,
    this.status,
    this.userName,
    this.userImage,
    this.appointmentShift,
    this.phone,
    this.name,
    this.description,
  });

  @override
  List<Object?> get props => [
        appointmentId,
        appointmentDate,
        status,
        userImage,
        userName,
      ];
}
