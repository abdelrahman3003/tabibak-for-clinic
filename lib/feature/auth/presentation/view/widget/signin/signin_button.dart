import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/core/widgets/app_snack_bar.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/managers/sign_in_bloc/signin_bloc.dart';

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
        //  final user = getit<Supabase>().client.auth.currentUser;
        if (state is SigninSuccess) {
          if (state.doctorEntity == null) {
            context.pushNamed(Routes.signupScreen);
            return;
          }
          context.pushNamedAndRemoveUntil(Routes.layOutScreen, (route) => true);
        }
        if (state is SigninError) {
          AppSnackBar.show(context: context, message: state.errorMessage);
        }
      },
      builder: (context, state) {
        final isLoading = state is SigninLoading;
        return AppButton(
          title: isLoading ? AppString.loggingIn : AppString.login,
          isLoading: isLoading,
          onPressed: isLoading ? null : onPressed,
        );
      },
    );
  }
}
