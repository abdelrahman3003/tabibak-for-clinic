import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/core/widgets/app_snack_bar.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/managers/sign_up_bloc/signup_bloc.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.nameController,
    required this.phoneController,
    required this.getSpecialization,
    required this.signupFormKey,
  });
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final int? Function() getSpecialization;
  final GlobalKey<FormState> signupFormKey;
  @override
  Widget build(BuildContext context) {
    log("email: ${emailController.text}, password: ${passwordController.text}, name: ${nameController.text}, phone: ${phoneController.text}, specialization: ${getSpecialization()}");

    final user = Supabase.instance.client.auth.currentUser;
    return BlocConsumer<SignupBloc, SignupState>(
      buildWhen: (previous, current) =>
          current is SignupLoading ||
          current is SignupInitial ||
          current is SignupError,
      listener: (context, state) {
        if (state is SignupError) {
          AppSnackBar.show(context: context, message: state.errorMessage);
        }
        if (state is SignupSuccess) {
          if (user?.emailConfirmedAt == null) {
            context.pushNamed(Routes.checkEmailScreen,
                arguments: emailController.text);
          } else {
            context.pushNamedAndRemoveUntil(
                Routes.professionalLicenseScreen, (route) => true,
                arguments: DoctorEntity(
                  name: nameController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  specialty: getSpecialization(),
                ));
          }
        }
      },
      builder: (context, state) {
        return AppButton(
          title: AppString.continueButton,
          isLoading: state is SignupLoading,
          onPressed: () {
            final specialization = getSpecialization();
            if (signupFormKey.currentState!.validate()) {
              user != null
                  ? context.pushNamed(
                      Routes.professionalLicenseScreen,
                      arguments: DoctorEntity(
                        name: user.userMetadata?['full_name'] ?? '',
                        email: user.email ?? '',
                        phone: user.phone ?? '',
                        specialty: specialization,
                      ),
                    )
                  : context.read<SignupBloc>().add(SignupRequestedEvent(
                          doctorEntity: DoctorEntity(
                        name: nameController.text,
                        email: emailController.text,
                        phone: phoneController.text,
                        password: passwordController.text,
                        specialty: specialization,
                      )));
            }
          },
        );
      },
    );
  }
}
