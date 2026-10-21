import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_padding.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_layout/clinic_layout_bloc.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/screens/clinic%20schedule/schedule_screen.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_layout_screen/clinic_init.dart';

class ClinicLayout extends StatelessWidget {
  const ClinicLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
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
            return ScheduleScreen(
                clinicInfoEntity: state.clinicInfoEntity,
                workingShiftsDays: state.workingShiftsDays);
          }

          if (state is ClinicLayoutEmpty) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      AppString.clinic,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                  ClinicInit(
                    title: AppString.setupYourClinic,
                    message: AppString.setupClinicSubtitle,
                    buttonTitle: AppString.addClinic,
                    icon: Icons.local_hospital_rounded,
                  ),
                ],
              ),
            );
          }

          if (state is ClinicLayoutFailed) {
            return Center(child: Text(state.errorMessage));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
