import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/widgets/circle_indicator_widget.dart';
import 'package:tabibak_for_clinic/core/widgets/dialogs.dart';
import 'package:tabibak_for_clinic/core/widgets/empty_widget.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_status_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/manager/appoinment/appointment_bloc.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/view/widget/appointment_screen/appointment_list.dart';

class FinishedAppointmentListStates extends StatelessWidget {
  const FinishedAppointmentListStates(
      {super.key, required this.appointmentStatusList});
  final List<AppointmentStatusEntity> appointmentStatusList;
  @override
  Widget build(BuildContext context) {
    List<AppointmentEntity>? appointmentList;

    return BlocConsumer<AppointmentBloc, AppointmentState>(
      listener: (context, state) {
        if (state is UpdateAppointmentStatusLoading) {
          Dialogs.showLoading(context);
        }
        if (state is UpdateAppointmentStatusSuccess) {
          appointmentList = state.updatedAppointmentList!;
          context.pop();
        }
        if (state is FinishedAppointmentsSuccess) {
          appointmentList = state.finishedList;
        }
      },
      builder: (context, state) {
        if (state is FinishedAppointmentsLoading || appointmentList == null) {
          return const CircleIndicatorWidget();
        }
        if (state is FinishedAppointmentsFailed) {
          return ErrorWidget(state.errorMessage);
        }

        return appointmentList!.isEmpty
            ? const EmptyWidget(
                message: "NO Finished Appointments",
              )
            : AppointmentList(
                type: 2,
                appointmentList: appointmentList!,
                appointmentStatusList: appointmentStatusList,
              );
      },
    );
  }
}
