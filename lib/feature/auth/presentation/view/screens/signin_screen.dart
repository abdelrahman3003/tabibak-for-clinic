import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/helper/validation.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/managers/sign_in_bloc/signin_bloc.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/auth_field.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/do_you_have_account.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/signin/signin_button.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/signin/signin_with_google_button.dart';

import '../widget/password_text_field.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});
  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

final signinKey = GlobalKey<FormState>();

class _SigninScreenState extends State<SigninScreen> {
  final emailController =
      TextEditingController(text: "abdelrahmatemsah29@gmail.com");
  final passwordController = TextEditingController(text: "Abdo123#");
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
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
            key: signinKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome Back",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text("Sign in to continue to Tabibak Clinic",
                    style: Theme.of(context).textTheme.titleMedium),
                40.hBox,
                AuthField(
                  controller: emailController,
                  label: "Email",
                  icon: Icons.email_outlined,
                  validator: Validation.validateEmail,
                ),
                const SizedBox(height: 20),
                PasswordTextField(
                  controller: passwordController,
                  validator: Validation.validatePassword,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.pushNamed(Routes.forgotPasswordScreen);
                    },
                    child: Text(
                      "Forgot Password?",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
                20.hBox,
                SigninButton(
                  onPressed: () {
                    if (signinKey.currentState!.validate()) {
                      context.read<SigninBloc>().add(SignInRequestedEvent(
                          email: emailController.text,
                          password: passwordController.text));
                    }
                  },
                ),
                20.hBox,
                Row(
                  children: [
                    const Expanded(child: Divider(thickness: 0.6)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "OR",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                    const Expanded(child: Divider(thickness: 0.6)),
                  ],
                ),
                20.hBox,
                const SigninWithGoogleButton(),
                40.hBox,
                DoHaveAccount(
                  title: "Don't have an account?",
                  subtitle: "Create Account",
                  onTap: () {
                    context.pop();
                    context.pushNamed(Routes.signupScreen);
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
