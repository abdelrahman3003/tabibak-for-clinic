import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/get_clinic_info_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_layout/clinic_layout_bloc.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/screens/clinic%20schedule/schedule_screen.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_layout_screen.dart/clinic_init.dart';

class ClinicLayout extends StatelessWidget {
  const ClinicLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClinicLayoutBloc(getit<GetClinicInfoUseCase>()),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
        child: BlocBuilder<ClinicLayoutBloc, ClinicLayoutState>(
          builder: (context, state) {
            if (state is ClinicLayoutLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ClinicLayoutSuccess) {
              return const ScheduleScreen();
            }

            if (state is ClinicLayoutEmpty) {
              return const ClinicInit();
            }

            if (state is ClinicLayoutFailed) {
              return Center(child: Text(state.errorMessage));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
