import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';

class SigninButton extends StatelessWidget {
  final Animation<Offset> animation;
  final GlobalKey<FormState> formKey;

  const SigninButton(
      {super.key, required this.animation, required this.formKey});

  @override
  Widget build(BuildContext context) {
    final isLoading = false;

    return SlideTransition(
        position: animation,
        child: AppButton(
          title: isLoading ? "Loging in." : "Log in",
          isLoading: isLoading,
          onPressed: () {
            if (!isLoading && formKey.currentState!.validate()) {}
          },
        ));
  }
}
