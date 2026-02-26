import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/core/widgets/app_snack_bar.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/managers/reset_password_bloc/reset_password_bloc.dart';

class ResetButtonStates extends StatelessWidget {
  const ResetButtonStates(
      {super.key,
      required this.formKey,
      required this.passwordController,
      required this.confirmPasswordController});
  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordFailure) {
          AppSnackBar.show(context: context, message: state.errorMessage);
        }
        if (state is ResetPasswordSuccess) {
          context.pushNamed(Routes.signinScreen);
        }
      },
      builder: (context, state) {
        return AppButton(
          title: AppString.resetPassword,
          isLoading: state is ResetPasswordInitial,
          onPressed: () {
            if (formKey.currentState!.validate()) {
              if (passwordController != confirmPasswordController) {
                AppSnackBar.show(
                  context: context,
                  message: "Not Matching Password",
                );
                return;
              }
              context
                  .read<ResetPasswordBloc>()
                  .add(ResetEvent(newPassword: passwordController.text));
            }
          },
        );
      },
    );
  }
}
