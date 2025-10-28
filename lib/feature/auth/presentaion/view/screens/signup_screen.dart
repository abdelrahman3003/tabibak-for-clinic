import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/constatnt/app_values.dart';
import 'package:tabibak_for_clinic/core/extenstion/naviagrion.dart';
import 'package:tabibak_for_clinic/core/extenstion/spacing.dart';
import 'package:tabibak_for_clinic/core/helper/validation.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/auth_field.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/do_you_have_account.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/password_textfiled.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/specailties_dropdwon.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

final TextEditingController nameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController phoneController = TextEditingController();

int? selectedSpecialization;
final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
User? user;

class _SignupScreenState extends State<SignupScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = ModalRoute.of(context)?.settings.arguments as User?;
    if (user != null) {
      nameController.text = user!.userMetadata?['full_name'] ?? "";
      emailController.text = user!.email ?? "";
      phoneController.text = user!.phone ?? "";
    }
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
                AuthField(
                  lable: "Full Name",
                  controller: nameController,
                  icon: Icons.person_outline,
                  validator: (v) => v == null || v.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 20),
                AuthField(
                  controller: emailController,
                  lable: "Email",
                  icon: Icons.email_outlined,
                  validator: Validation.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                SpecailtiesDropdwon(
                  onChangedSpecialization: (value) {
                    selectedSpecialization = value;
                  },
                ),
                const SizedBox(height: 20),
                AuthField(
                  controller: phoneController,
                  lable: "Phone Number",
                  icon: Icons.phone_outlined,
                  validator: Validation.validateNumber,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                PasswordTextfiled(
                  controller: passwordController,
                  validator: Validation.validatePassword,
                ),
                30.hBox,
                AppButton(
                  title: "Continue",
                  onPressed: () {
                    if (signupFormKey.currentState!.validate()) {
                      context.pushNamed(
                        Routes.professionalLinceseScreen,
                        arguments: {
                          "name": nameController.text,
                          "email": emailController.text,
                          "phone": phoneController.text,
                          "password": passwordController.text,
                          "specialization": selectedSpecialization,
                          "user": user
                        },
                      );
                    }
                  },
                ),
                40.hBox,
                DoHaveAccount(
                  title: "Already have an account?",
                  subtitle: "Sign In",
                  onTap: () {
                    context.pop();
                    context.pushNamed(Routes.singinScreen);
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
