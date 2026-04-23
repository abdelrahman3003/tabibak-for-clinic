import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/manager/appointment_details/appointment_details_bloc.dart';

class AppointmentDetailsCancelButtonStates extends StatelessWidget {
  const AppointmentDetailsCancelButtonStates(
      {super.key, required this.appointmentId});
  final int appointmentId;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppointmentDetailsBloc, AppointmentDetailsState>(
      listener: (context, state) {
        if (state is CancelAppointmentFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.red,
            ),
          );
        }
        if (state is CancelAppointmentSuccess) {
          context.pop();
          // Optionally, you can also pop the screen or refresh the details
        }
      },
      builder: (context, state) {
        return AppButton(
          title: "Cancel Appointment",
          color: AppColors.red,
          isLoading: state is CancelAppointmentLoading,
          onPressed: () {
            context.read<AppointmentDetailsBloc>().add(
                  CancelAppointmentEvent(appointmentId: appointmentId),
                );
          },
        );
      },
    );
  }
}
