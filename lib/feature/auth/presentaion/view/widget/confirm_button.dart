import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/core/widgets/app_snack_bar.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/managers/sign_up_bloc/signup_bloc.dart';

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({super.key, this.onPressed});

  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupBloc, SignupState>(
      buildWhen: (previous, current) =>
          current is SignupSuccess ||
          current is SignupError ||
          current is SignupLoading ||
          current is UploadFileSuccess,
      listener: (context, state) {
        if (state is SignupSuccess) {
          context.pushNamed(Routes.layOutScreen);
        }
        if (state is SignupError) {
          AppSnackBar.show(context: context, message: state.errorMessage);
        }
      },
      builder: (context, state) {
        return AppButton(
          title: "Confirm",
          isLoading: state is SignupLoading,
          onPressed: state is UploadFileSuccess ? onPressed : null,
        );
      },
    );
  }
}
