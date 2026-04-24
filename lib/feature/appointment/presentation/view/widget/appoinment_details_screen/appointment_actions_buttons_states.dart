import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/helper/app_snack_bar.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/manager/appointment_details/appointment_details_bloc.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appoinment_details_screen/appointment_actions_buttons.dart';

class AppointmentActionsButtonsStates extends StatelessWidget {
  const AppointmentActionsButtonsStates(
      {super.key, required this.appointmentId});
  final int appointmentId;
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AppointmentDetailsBloc>();
    return BlocConsumer<AppointmentDetailsBloc, AppointmentDetailsState>(
      listener: (context, state) {
        if (state is AppointmentActionFailure) {
          AppSnackBar.error(context, state.message);
        }
        if (state is AppointmentActionSuccess) {
          context.pop();
          AppSnackBar.show(context, message: "Action completed successfully");
        }
      },
      builder: (context, state) {
        return AppointmentActionButtons(
          isCompleteLoading: state is AppointmentActionLoading &&
              state.actionType == "complete",
          isFollowUpLoading: state is AppointmentActionLoading &&
              state.actionType == "followUp",
          isCancelLoading:
              state is AppointmentActionLoading && state.actionType == "cancel",
          onComplete: () {
            bloc.add(UpdateAppointmentEvent(
                appointmentId: appointmentId, actionType: "complete"));
          },
          onFollowUp: (date) {
            bloc.add(
                SetFollowUpEvent(appointmentId: appointmentId, date: date));
          },
          onCancel: () {
            bloc.add(UpdateAppointmentEvent(
                appointmentId: appointmentId, actionType: "cancel"));
          },
        );
      },
    );
  }
}
