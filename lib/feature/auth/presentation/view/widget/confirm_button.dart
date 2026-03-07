import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/core/widgets/app_snack_bar.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/managers/license_bloc/license_bloc.dart';

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({super.key, this.onPressed, required this.email});
  final String email;
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LicenseBloc, LicenseState>(
      buildWhen: (previous, current) =>
          current is UploadFileSuccess ||
          current is LicenseLoading ||
          current is LicenseError,
      listener: (context, state) {
        if (state is LicenseSuccess) {
          context.pushNamed(Routes.layOutScreen);
        }
        if (state is LicenseError) {
          AppSnackBar.show(context: context, message: state.errorMessage);
        }
      },
      builder: (context, state) {
        return AppButton(
          title: AppString.confirm,
          isLoading: state is LicenseLoading,
          onPressed: onPressed,
        );
      },
    );
  }
}
