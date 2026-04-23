import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_widget.dart';
import 'package:tabibak_for_clinic/core/widgets/app_loading_widget.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/manager/appointment_details/appointment_details_bloc.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appoinment_details_screen/appointment_details_body.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  const AppointmentDetailsScreen({super.key});

  // ── Status helpers ──────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const AppBarWidget(title: "Appointment Details"),
      body: Center(
        child: BlocBuilder<AppointmentDetailsBloc, AppointmentDetailsState>(
          buildWhen: (previous, current) =>
              current is GetAppointmentDetailsSuccess ||
              current is GetAppointmentDetailsFailure ||
              current is GetAppointmentDetailsLoading,
          builder: (context, state) {
            if (state is GetAppointmentDetailsLoading) {
              return const AppLoadingWidget();
            }
            if (state is GetAppointmentDetailsSuccess) {
              return AppointmentDetailsBody(
                  appointmentEntity: state.appointmentEntity);
            }
            if (state is GetAppointmentDetailsFailure) {
              return Text(state.message);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

// ── Patient header card ──────────────────────────────────────────────

// ── Section card wrapper ─────────────────────────────────────────────

// ── Single detail row ────────────────────────────────────────────────
