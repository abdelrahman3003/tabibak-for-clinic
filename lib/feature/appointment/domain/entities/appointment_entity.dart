import 'package:equatable/equatable.dart';

class AppointmentEntity extends Equatable {
  final int? appointmentId;
  final String? doctorId;
  final DateTime? appointmentDate;
  final String? statusEn;
  final String? statusAr;
  final int? statusId;
  final String? userId;
  final String? userImage;
  final int? appointmentShift;
  final String? phone;
  final String? name;
  final String? description;

  const AppointmentEntity({
    this.appointmentId,
    this.doctorId,
    this.appointmentDate,
    this.statusEn,
    this.statusAr,
    this.statusId,
    this.userId,
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
        statusEn,
        statusAr,
        userImage,
        userId,
        name,
        appointmentShift,
        phone,
        description,
        statusId
      ];
}
