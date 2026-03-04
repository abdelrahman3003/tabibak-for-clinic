import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/constant/app_padding.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/helper/validation.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/managers/sign_up_bloc/signup_bloc.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/auth_field.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/do_you_have_account.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/password_text_field.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/specialties_drop_down.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart';

class ProfessionalLicenseArgs {
  final DoctorEntity doctorEntity;
  final SignupBloc signupBloc;

  ProfessionalLicenseArgs({
    required this.doctorEntity,
    required this.signupBloc,
  });
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  User? user;
  int? selectedSpecialization;
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  TextEditingController? nameController;
  TextEditingController? emailController;
  TextEditingController? passwordController;
  TextEditingController? phoneController;
  @override
  void initState() {
    super.initState();
    context.read<SignupBloc>().add(const GetSpecialtiesRequested());
    user = getit<Supabase>().client.auth.currentUser;
    nameController = TextEditingController(text: "abdelrahman temsah");
    emailController =
        TextEditingController(text: "abdelrahmatemsah29@gmail.com");
    passwordController = TextEditingController(text: "Abdo123456");
    phoneController = TextEditingController(text: "01096666666");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          padding:
              const EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
          child: Form(
            key: signupFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppString.createAccount,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  AppString.signupSubtitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                40.hBox,
                if (user != null) ...[
                  Text(user!.userMetadata?['full_name'] ?? ''),
                  Text(user!.email ?? ''),
                  Text(user!.phone ?? ''),
                  const SizedBox(height: 20),
                ] else ...[
                  AuthField(
                    label: AppString.fullName,
                    controller: nameController,
                    icon: Icons.person_outline,
                    validator: (v) =>
                        v == null || v.isEmpty ? AppString.required : null,
                  ),
                  const SizedBox(height: 20),
                  AuthField(
                    controller: emailController,
                    label: AppString.email,
                    icon: Icons.email_outlined,
                    validator: Validation.validateEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  AuthField(
                    controller: phoneController,
                    label: AppString.phoneNumber,
                    icon: Icons.phone_outlined,
                    validator: Validation.validateNumber,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  PasswordTextField(
                    controller: passwordController,
                    validator: Validation.validatePassword,
                  ),
                  const SizedBox(height: 20),
                ],
                SpecialtiesDropDown(
                  onChangedSpecialization: (value) {
                    selectedSpecialization = value;
                  },
                ),
                30.hBox,
                AppButton(
                  title: AppString.continueButton,
                  onPressed: () {
                    if (signupFormKey.currentState!.validate()) {
                      context.pushNamed(Routes.professionalLicenseScreen,
                          arguments: ProfessionalLicenseArgs(
                            doctorEntity: DoctorEntity(
                              name: nameController?.text,
                              email: emailController?.text,
                              phone: phoneController?.text,
                              password: passwordController?.text,
                              specialty: selectedSpecialization,
                              isRegistered: true,
                            ),
                            signupBloc: context.read<SignupBloc>(),
                          ));
                    }
                  },
                ),
                40.hBox,
                DoHaveAccount(
                  title: AppString.alreadyHaveAccount,
                  subtitle: AppString.signIn,
                  onTap: () {
                    context.pop();
                    context.pushNamed(Routes.signinScreen);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
