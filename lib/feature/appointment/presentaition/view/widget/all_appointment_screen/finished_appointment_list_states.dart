import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/widgets/circle_indicator_widget.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_status_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/manager/appointment_type/appointment_type_bloc.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/view/widget/appointment_screen/appointment_list.dart';

class FinishedAppointmentListStates extends StatelessWidget {
  const FinishedAppointmentListStates(
      {super.key, required this.appointmentStatusList});
  final List<AppointmentStatusEntity> appointmentStatusList;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentTypeBloc, AppointmentTypeState>(
      builder: (context, state) {
        if (state is FinishedAppointmentsLoading) {
          return const CircleIndicatorWidget();
        }
        if (state is FinishedAppointmentsFailed) {
          return ErrorWidget(state.errorMessage);
        }
        if (state is FinishedAppointmentsSuccess) {
          return AppointmentList(
            appointmentList: state.upcomingList,
            appointmentStatusList: appointmentStatusList,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
