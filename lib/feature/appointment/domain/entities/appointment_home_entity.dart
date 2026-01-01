import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_status_entity.dart';

class AppointmentHomeEntity {
  final List<AppointmentEntity>? appointmentList;
  final List<AppointmentStatusEntity>? appointmentStatusList;

  const AppointmentHomeEntity({
    this.appointmentList,
    this.appointmentStatusList,
  });

  AppointmentHomeEntity copyWith({
    List<AppointmentEntity>? appointmentList,
    List<AppointmentStatusEntity>? appointmentStatusList,
  }) {
    return AppointmentHomeEntity(
      appointmentList: appointmentList ?? this.appointmentList,
      appointmentStatusList:
          appointmentStatusList ?? this.appointmentStatusList,
    );
  }
}
