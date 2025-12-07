import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/core/widgets/app_snack_bar.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_info/clinic_info_bloc.dart';

class ClinicInfoButtonStates extends StatelessWidget {
  const ClinicInfoButtonStates({super.key, this.onPressed});
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClinicInfoBloc, ClinicInfoState>(
      listener: (context, state) {
        if (state is ClinicInfoFailed) {
          AppSnackBar.show(context: context, message: state.errorMessage);
        } else if (state is ClinicInfoSuccess) {
          context.pushNamed(Routes.clinicDaysScreen);
        }
      },
      builder: (context, state) {
        return AppButton(
            title: "Continue",
            isLoading: state is ClinicInfoLoading,
            onPressed: onPressed);
      },
    );
  }
}
