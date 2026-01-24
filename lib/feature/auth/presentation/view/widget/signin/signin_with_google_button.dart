import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/helper/shared_pref_helper.dart'
    show SharedPrefKeys, SharedPrefHelper;
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_snack_bar.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/managers/sign_in_bloc/signin_bloc.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/signin/custom_signin_button.dart';

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
          AppSnackBar.show(context: context, message: state.errorMessage);
        } else if (state is SigninWithGoogleSuccess) {
          if (state.signinResultEntity.isRegistered) {
            getit<SharedPrefHelper>()
                .setData(key: SharedPrefKeys.step, value: 2);
            context.pushNamed(Routes.layOutScreen);
          } else {
            context.pushNamed(Routes.signupScreen,
                arguments: state.signinResultEntity.user);
          }
        }
      },
      builder: (context, state) {
        final isLoading = state is SigninWithGoogleLoading;
        return CustomSigninButton(
          isLoading: isLoading,
          onPressed: () {
            context.read<SigninBloc>().add(const SignInWithGoogleEvent());
          },
        );
      },
    );
  }
}
