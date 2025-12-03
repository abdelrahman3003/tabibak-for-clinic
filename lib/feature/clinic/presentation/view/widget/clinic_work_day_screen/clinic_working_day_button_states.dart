import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/core/widgets/dialogs.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_working_day/clinic_working_day_bloc.dart';

class ClinicWorkDayButtonStates extends StatelessWidget {
  const ClinicWorkDayButtonStates({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClinicWorkingDayBloc, ClinicWorkingDayState>(
      listener: (context, state) {
        if (state is ClinicWorkingDayFailed) {
          Dialogs.errorDialog(context, state.errorMessage);
        } else if (state is ClinicWorkingDaySuccess) {
          context.pushNamed(Routes.clinicShiftsTimeScreen);
        }
      },
      builder: (context, state) {
        return AppButton(
          title: "Continue",
          isLoading: state is ClinicWorkingDayLoading,
          onPressed: () {
            context.pushNamed(Routes.clinicDaysScreen);
          },
        );
      },
    );
  }
}
