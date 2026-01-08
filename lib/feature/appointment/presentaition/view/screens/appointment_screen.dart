import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/widgets/app_text_error.dart';
import 'package:tabibak_for_clinic/core/widgets/circle_indicator_widget.dart';
import 'package:tabibak_for_clinic/core/widgets/dialogs.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_home_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/usecase/get_appointments_home_use_case.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/usecase/update_appointment_status_use_case.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/manager/appoinment/appointment_bloc.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/view/widget/appointment_screen/appointment_body.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppointmentBloc(
        getit<GetAppointmentsUseCase>(),
        getit<UpdateAppointmentStatusUseCase>(),
      ),
      child: BlocConsumer<AppointmentBloc, AppointmentState>(
        buildWhen: (previous, current) =>
            current is AppointmentLoading ||
            current is AppointmentSuccess ||
            current is AppointmentFailed ||
            current is UpdateAppointmentStatusSuccess,
        listener: (context, state) {
          if (state is UpdateAppointmentStatusLoading) {
            Dialogs.showLoading(context);
          }
          if (state is UpdateAppointmentStatusSuccess) {
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is AppointmentLoading) {
            return const Center(child: CircleIndicatorWidget());
          }

          if (state is AppointmentFailed) {
            return Center(child: AppTextError(error: state.errorMessage));
          }

          if (state is AppointmentSuccess) {
            return AppointmentBody(
                appointmentHomeEntity: state.appointmentHomeEntity);
          }
          if (state is UpdateAppointmentStatusSuccess) {
            return AppointmentBody(
                appointmentHomeEntity: AppointmentHomeEntity(
                    appointmentTodayList: state.updatedAppointmentList));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
