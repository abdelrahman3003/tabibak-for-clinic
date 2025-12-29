import 'package:equatable/equatable.dart';

class AppointmentEntity extends Equatable {
  final String? appointmentTime;
  final DateTime? appointmentDate;
  final String? status;
  final String? userName;
  final String? userImage;

  const AppointmentEntity({
    required this.appointmentTime,
    required this.appointmentDate,
    required this.status,
    required this.userName,
    required this.userImage,
  });

  @override
  List<Object?> get props => [
        appointmentDate,
        appointmentTime,
        status,
        userImage,
        userName,
      ];
}
