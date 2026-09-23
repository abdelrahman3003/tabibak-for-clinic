import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_padding.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_layout/clinic_layout_bloc.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_layout_screen/clinic_init.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/schedule_screen/clinic_reports_dashboard.dart';

class ClinicReportsScreen extends StatelessWidget {
  const ClinicReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.horizontal),
      child: BlocBuilder<ClinicLayoutBloc, ClinicLayoutState>(
        buildWhen: (previous, current) =>
            current is ClinicLayoutLoading ||
            current is ClinicLayoutSuccess ||
            current is ClinicLayoutEmpty ||
            current is ClinicLayoutFailed,
        builder: (context, state) {
          if (state is ClinicLayoutLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ClinicLayoutSuccess) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      state.clinicInfoEntity.clinicName ?? AppString.clinicReports,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  ClinicReportsDashboard(clinic: state.clinicInfoEntity),
                ],
              ),
            );
          }
          if (state is ClinicLayoutEmpty) return const ClinicInit();
          if (state is ClinicLayoutFailed) {
            return Center(child: Text(state.errorMessage));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
