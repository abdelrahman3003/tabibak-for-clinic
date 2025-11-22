import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/extenstion/naviagrion.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/core/widgets/snackBar_widget.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/managers/sign_in_bloc/signin_bloc.dart';

class SigninButton extends StatelessWidget {
  final Function()? onPressed;
  const SigninButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigninBloc, SigninState>(
      buildWhen: (previous, current) =>
          current is SigninLoading ||
          current is SigninSuccess ||
          current is SigninError,
      listener: (context, state) {
        if (state is SigninSuccess) {
          context.pushNamed(Routes.layOutScreen);
        }
        if (state is SigninError) {
          showSnackBar(context: context, messege: state.errorMessage);
        }
      },
      builder: (context, state) {
        final isLoading = state is SigninLoading;
        return AppButton(
          title: isLoading ? "Loging in..." : "Log in",
          isLoading: isLoading,
          onPressed: isLoading ? null : onPressed,
        );
      },
    );
  }
}
