import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/extenstion/naviagrion.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/managers/signup/signup_bloc.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key, this.onPressed});
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state is SignupError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
        if (state is SignupSuccess) {
          context.pushNamed(Routes.singinView);
        }
      },
      builder: (context, state) {
        return AppButton(
          title: "Register",
          isLoading: state is SignupLoading,
          onPressed: onPressed,
        );
      },
    );
  }
}
