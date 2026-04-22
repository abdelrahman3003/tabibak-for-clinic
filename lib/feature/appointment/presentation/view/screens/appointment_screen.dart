import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/widgets/app_loading_widget.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/manager/appoinment/appointment_bloc.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appointment_screen/appointment_body.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => getit<AppointmentBloc>(),
        child: BlocBuilder<AppointmentBloc, AppointmentState>(
          builder: (context, state) {
            if (state is AppointmentLoading) {
              return const Center(child: AppLoadingWidget());
            }
            if (state is AppointmentFailed) {
              return Center(child: ErrorWidget(state.errorMessage));
            }
            if (state is AppointmentSuccess) {
              return AppointmentBody(
                appointmentList: state.appointmentsList!,
                doctorName: state.doctor?.name ?? "Unknown Doctor",
              );
            }
            return const SizedBox();
          },
        ));
  }
}
