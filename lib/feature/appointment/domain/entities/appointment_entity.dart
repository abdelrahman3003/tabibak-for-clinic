import 'package:equatable/equatable.dart';

class AppointmentEntity extends Equatable {
  final int? appointmentId;
  final String? doctorId;
  final DateTime? appointmentDate;
  final String? appointmentTypeEn;
  final String? appointmentTypeAr;
  final String? statusEn;
  final String? statusAr;
  final int? statusId;
  final String? userId;
  final String? userImage;
  final String? phone;
  final int? appointmentMorningShiftId;
  final int? appointmentEveningShiftId;
  final String? name;
  final String? description;
  final DateTime? followUpDate;
  const AppointmentEntity({
    this.appointmentId,
    this.appointmentTypeEn,
    this.appointmentTypeAr,
    this.doctorId,
    this.appointmentDate,
    this.statusEn,
    this.statusAr,
    this.statusId,
    this.userId,
    this.userImage,
    this.appointmentMorningShiftId,
    this.appointmentEveningShiftId,
    this.phone,
    this.name,
    this.description,
    this.followUpDate,
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
        appointmentMorningShiftId,
        appointmentEveningShiftId,
        phone,
        description,
        statusId
      ];
}
