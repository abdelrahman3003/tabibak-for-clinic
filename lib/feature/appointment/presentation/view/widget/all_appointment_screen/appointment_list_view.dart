import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/manager/all_appointment/all_appointments_bloc.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appointment_screen/appointment_list.dart';

enum AppointmentType { upcoming, finished, canceled }

class AppointmentListView extends StatelessWidget {
  const AppointmentListView({
    super.key,
    required this.type,
    required this.appointments,
  });

  final AppointmentType type;
  final List<AppointmentEntity> appointments;
  @override
  Widget build(BuildContext context) {
    return AppointmentList(
      showActions: type == AppointmentType.upcoming,
      appointmentList: appointments,
      onStatusChanged: (appointmentId, statusIndex) {
        context.read<AllAppointmentsBloc>().add(
              UpdateAppointmentStatusEvent(
                statusIndex: statusIndex!,
                appointmentId: appointmentId!,
              ),
            );
      },
    );
  }
}
