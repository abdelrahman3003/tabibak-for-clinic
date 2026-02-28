import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/helper/validation.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/auth_field.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/do_you_have_account.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/password_text_field.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/specialties_drop_down.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

int? selectedSpecialization;
final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
User user = getit<Supabase>().client.auth.currentUser!;

class _SignupScreenState extends State<SignupScreen> {
  User? user;
  int? selectedSpecialization;
  TextEditingController? nameController;
  TextEditingController? emailController;
  TextEditingController? passwordController;
  TextEditingController? phoneController;
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: "abdo");
    emailController =
        TextEditingController(text: "abdelrahmatemsah29@gmail.com");
    passwordController = TextEditingController(text: "Abdo123#");
    phoneController = TextEditingController(text: "01032970712");
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
                  "Create Account",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  "Sign up to continue to Tabibak Clinic",
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
                    label: "Full Name",
                    controller: nameController,
                    icon: Icons.person_outline,
                    validator: (v) =>
                        v == null || v.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 20),
                  AuthField(
                    controller: emailController,
                    label: "Email",
                    icon: Icons.email_outlined,
                    validator: Validation.validateEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  AuthField(
                    controller: phoneController,
                    label: "Phone Number",
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
                  title: "Continue",
                  onPressed: () {
                    if (signupFormKey.currentState!.validate()) {
                      context.pushNamed(Routes.professionalLicenseScreen,
                          arguments: DoctorEntity(
                            name: nameController?.text,
                            email: emailController?.text,
                            phone: phoneController?.text,
                            password: passwordController?.text,
                            specialty: selectedSpecialization,
                            isRegistered: true,
                          ));
                    }
                  },
                ),
                40.hBox,
                DoHaveAccount(
                  title: "Already have an account?",
                  subtitle: "Sign In",
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
