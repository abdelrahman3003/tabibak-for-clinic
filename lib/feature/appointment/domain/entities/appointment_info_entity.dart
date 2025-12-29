import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';

class AppointmentInfoEntity extends Equatable {
  final String? doctorName;
  final int? appointmentCount;
  final List<AppointmentEntity>? appointmentList;

  const AppointmentInfoEntity({
    required this.doctorName,
    required this.appointmentList,
    required this.appointmentCount,
  });

  @override
  List<Object?> get props => [doctorName, appointmentCount, appointmentList];
}
