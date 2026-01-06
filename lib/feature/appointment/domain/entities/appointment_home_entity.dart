import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_status_entity.dart';

class AppointmentHomeEntity {
  final List<AppointmentEntity>? appointmentTodayList;
  final List<AppointmentStatusEntity>? appointmentStatusList;

  const AppointmentHomeEntity({
    this.appointmentTodayList,
    this.appointmentStatusList,
  });

  AppointmentHomeEntity copyWith({
    List<AppointmentEntity>? appointmentList,
    List<AppointmentStatusEntity>? appointmentStatusList,
  }) {
    return AppointmentHomeEntity(
      appointmentTodayList: appointmentTodayList ?? appointmentTodayList,
      appointmentStatusList:
          appointmentStatusList ?? this.appointmentStatusList,
    );
  }
}
