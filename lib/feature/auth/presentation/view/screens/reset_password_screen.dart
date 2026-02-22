import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/helper/validation.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/core/widgets/app_snack_bar.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/password_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                30.hBox,
                Text(
                  AppString.createNewPassword,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                ),
                12.hBox,
                Text(
                  AppString.resetPasswordSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textLight,
                        height: 1.5,
                      ),
                ),
                40.hBox,
                PasswordTextField(
                  controller: _passwordController,
                  hint: AppString.newPassword,
                ),
                20.hBox,
                PasswordTextField(
                  controller: _confirmPasswordController,
                  hint: AppString.confirmNewPassword,
                  validator: (value) => Validation.validateEmail(value),
                ),
                60.hBox,
                AppButton(
                  title: AppString.resetPassword,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      AppSnackBar.show(
                        context: context,
                        message: AppString.passwordResetSuccess,
                      );
                      context.pushNamedAndRemoveUntil(
                          Routes.signinScreen, (route) => false);
                    }
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
