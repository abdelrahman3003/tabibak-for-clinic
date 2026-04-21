import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/widgets/app_loading_widget.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_status_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/manager/appoinment/appointment_bloc.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appointment_screen/appointment_empty.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appointment_screen/appointment_list.dart';

class FinishedAppointmentListStates extends StatelessWidget {
  const FinishedAppointmentListStates(
      {super.key, required this.appointmentStatusList});
  final List<AppointmentStatusEntity> appointmentStatusList;

  @override
  Widget build(BuildContext context) {
    List<AppointmentEntity>? appointmentList;

    return BlocConsumer<AppointmentBloc, AppointmentState>(
      listenWhen: (_, curr) => curr is FinishedAppointmentsSuccess,
      listener: (context, state) {
        if (state is FinishedAppointmentsSuccess) {
          appointmentList = state.finishedList;
        }
      },
      builder: (context, state) {
        if (state is FinishedAppointmentsLoading || appointmentList == null) {
          return const Center(child: AppLoadingWidget());
        }
        if (state is FinishedAppointmentsFailed) {
          return ErrorWidget(state.errorMessage);
        }

        return appointmentList!.isEmpty
            ? AppointmentEmpty(title: AppString.noFinishedAppointments)
            : AppointmentList(
                type: 2,
                showActions: false,
                appointmentList: appointmentList!,
                appointmentStatusList: appointmentStatusList,
              );
      },
    );
  }
}
