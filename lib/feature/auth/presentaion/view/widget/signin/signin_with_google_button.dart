import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/extenstion/naviagrion.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/snackBar_widget.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/managers/sign_in_bloc/signin_bloc.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/signin/custom_signin_button.dart';

class SigninWithGoogleButton extends StatelessWidget {
  const SigninWithGoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigninBloc, SigninState>(
      buildWhen: (previous, current) =>
          current is SigninWithGoogleSuccess ||
          current is SigninWithGoogleError ||
          current is SigninWithGoogleLoading,
      listener: (context, state) {
        if (state is SigninWithGoogleError) {
          showSnackBar(context: context, messege: state.errorMessage);
        } else if (state is SigninWithGoogleSuccess) {
          state.signinResultEntity.isRegistered
              ? context.pushNamed(Routes.homeScreen)
              : context.pushNamed(Routes.signupScreen,
                  arguments: state.signinResultEntity.user);
        }
      },
      builder: (context, state) {
        final isLoading = state is SigninWithGoogleLoading;
        return CustomSigninButton(
          isLoading: isLoading,
          onPressed: () {
            context.read<SigninBloc>().add(SignInWithGoogleEvent());
          },
        );
      },
    );
  }
}
