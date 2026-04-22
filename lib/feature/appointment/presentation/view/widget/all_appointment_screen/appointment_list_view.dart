import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/manager/all_appointment_bloc/bloc/all_appointments_bloc.dart';
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
                statusIndex: statusIndex,
                appointmentId: appointmentId,
              ),
            );
      },
    );
  }

  void _refreshList(BuildContext context) {
    final bloc = context.read<AllAppointmentsBloc>();
    switch (type) {
      case AppointmentType.upcoming:
        bloc.add(GetUpcomingAppointmentsEvent());
        break;
      case AppointmentType.finished:
        bloc.add(GetFinishedAppointmentsEvent());
        break;
      case AppointmentType.canceled:
        bloc.add(GetCanceledAppointmentsEvent());
        break;
    }
  }

  String _getEmptyTitle() {
    switch (type) {
      case AppointmentType.upcoming:
        return AppString.noUpcomingAppointments;
      case AppointmentType.finished:
        return AppString.noFinishedAppointments;
      case AppointmentType.canceled:
        return AppString.noCanceledAppointments;
    }
  }
}
