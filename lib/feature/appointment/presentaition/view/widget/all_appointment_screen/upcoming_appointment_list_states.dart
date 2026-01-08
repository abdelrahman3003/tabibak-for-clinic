import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/widgets/circle_indicator_widget.dart';
import 'package:tabibak_for_clinic/core/widgets/dialogs.dart';
import 'package:tabibak_for_clinic/core/widgets/empty_widget.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_status_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/manager/appointment_type/appointment_type_bloc.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/view/widget/appointment_screen/appointment_list.dart';

class UpcomingAppointmentListStates extends StatelessWidget {
  const UpcomingAppointmentListStates(
      {super.key, required this.appointmentStatusList});
  final List<AppointmentStatusEntity> appointmentStatusList;
  @override
  Widget build(BuildContext context) {
    List<AppointmentEntity>? appointmentList;
    return BlocConsumer<AppointmentTypeBloc, AppointmentTypeState>(
      listener: (context, state) {
        if (state is UpdateAppointmentTypeStatusLoading) {
          Dialogs.showLoading(context);
        }
        if (state is UpdateAppointmentTypeStatusSuccess) {
          appointmentList = state.updatedAppointmentList!;
          context.pop();
        }
        if (state is UpcomingAppointmentsSuccess) {
          appointmentList = state.upcomingList;
        }
      },
      builder: (context, state) {
        if (state is UpcomingAppointmentsLoading || appointmentList == null) {
          return const CircleIndicatorWidget();
        }
        if (state is UpcomingAppointmentsFailed) {
          return ErrorWidget(state.errorMessage);
        }

        return appointmentList!.isEmpty
            ? const EmptyWidget(
                message: "NO Upcoming Appointments",
              )
            : AppointmentList(
                type: 1,
                appointmentList: appointmentList!,
                appointmentStatusList: appointmentStatusList,
              );
      },
    );
  }
}
