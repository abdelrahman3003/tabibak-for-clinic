import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/core/widgets/app_snack_bar.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/managers/forgot_password_bloc/forgot_password_bloc.dart';

class SendOtpButtonStates extends StatelessWidget {
  const SendOtpButtonStates(
      {super.key, required this.formKey, required this.emailController});
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordFailure) {
          AppSnackBar.show(context: context, message: state.errorMessage);
        }
        if (state is ForgotPasswordSuccess) {
          context.pushNamed(Routes.otpVerificationScreen);
        }
      },
      builder: (context, state) {
        return AppButton(
          title: AppString.sendCode,
          isLoading: state is ForgotPasswordLoading,
          onPressed: () {
            if (formKey.currentState!.validate()) {
              context
                  .read<ForgotPasswordBloc>()
                  .add(SendOtpEvent(email: emailController.text));
            }
          },
        );
      },
    );
  }
}
