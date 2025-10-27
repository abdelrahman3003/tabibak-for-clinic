import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/constatnt/app_string.dart';
import 'package:tabibak_for_clinic/core/extenstion/naviagrion.dart';
import 'package:tabibak_for_clinic/core/extenstion/spacing.dart';
import 'package:tabibak_for_clinic/core/helper/validation.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/auth_field.dart';
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

class _SignupScreenState extends State<SignupScreen> {
  get onChangedSpecialization => null;

  @override
  void initState() {
    super.initState();
    emailController.text = "doctor@example.com";
    passwordController.text = "123456";
    nameController.text = "Dr. Ahmed Ali";
    phoneController.text = "01012345678";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBG,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: _buildForm(context),
                ),
              ),
              _buildContinueButton(context),
              20.hBox
            ],
          ),
        ),
      ),
    );
  }

  AppButton _buildContinueButton(BuildContext context) {
    return AppButton(
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
            },
          );
        }
      },
    );
  }

  Column _buildForm(BuildContext context) {
    return Column(
      children: [
        Form(
          key: signupFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.hBox,
              Center(
                child: Text(
                  AppString.signUp,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                ),
              ),
              30.hBox,
              Text(
                "Let's get to know you",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: AppColors.primary),
              ),
              10.hBox,
              Text(
                "Please fill in your personal details below to continue registration.",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w300),
              ),
              30.hBox,
              AuthField(lable: "Full Name", controller: nameController),
              10.hBox,
              AuthField(
                lable: AppString.email,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                validator: (value) => Validation.validateEmail(value),
              ),
              10.hBox,
              SpecailtiesDropdwon(
                onChangedSpecialization: (value) {
                  selectedSpecialization = value;
                },
              ),
              10.hBox,
              AuthField(
                lable: AppString.phoneNumber,
                keyboardType: TextInputType.number,
                controller: phoneController,
                validator: (value) => Validation.validateNumber(value),
              ),
              10.hBox,
              PasswordTextfiled(
                controller: passwordController,
                validator: (value) => Validation.validatePassord(value),
              ),
              30.hBox,
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
