import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/core/widgets/app_snack_bar.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_creation/clinic_shift/clinic_shift_bloc.dart';

class ClinicShiftButtonStates extends StatelessWidget {
  const ClinicShiftButtonStates({
    super.key,
    this.onPressed,
  });

  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClinicShiftBloc, ClinicShiftState>(
      listener: (context, state) {
        if (state is ClinicShiftFailed) {
          AppSnackBar.show(context: context, message: state.errorMessage);
        } else if (state is ClinicShiftSuccess) {
          context.pushNamed(Routes.layOutScreen);
        }
      },
      builder: (context, state) {
        return AppButton(
          title: "Save",
          isLoading: state is ClinicShiftLoading,
          onPressed: onPressed,
        );
      },
    );
  }
}
