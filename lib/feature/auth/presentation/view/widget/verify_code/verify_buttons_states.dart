import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/core/widgets/app_snack_bar.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/managers/verifiy_code_bloc/verify_code_bloc.dart';

class VerifyButtonsStates extends StatelessWidget {
  const VerifyButtonsStates(
      {super.key,
      required this.email,
      required this.focusNodes,
      required this.controllers});
  final String email;
  final List<FocusNode> focusNodes;
  final List<TextEditingController> controllers;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerifyCodeBloc, VerifyCodeState>(
      listener: (context, state) {
        if (state is VerifyCodeFailure) {
          AppSnackBar.show(context: context, message: state.errorMessage);
        }
        if (state is ResendOtpFailure) {
          AppSnackBar.show(context: context, message: state.errorMessage);
        }
        if (state is VerifyCodeSuccess) {
          context.pushNamed(Routes.resetPasswordScreen);
        }
      },
      builder: (context, state) {
        return AppButton(
          title: AppString.verifyCode,
          isLoading: state is VerifyCodeLoading,
          onPressed: () {
            final otp = controllers.map((e) => e.text).join();
            context
                .read<VerifyCodeBloc>()
                .add(VerifyOtpEvent(email: email, otp: otp));
          },
        );
      },
    );
  }
}
