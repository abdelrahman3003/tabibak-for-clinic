import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extenstion/naviagrion.dart';
import 'package:tabibak_for_clinic/core/extenstion/spacing.dart';
import 'package:tabibak_for_clinic/core/helper/validation.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/auth_field.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/do_you_have_account.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/signin_button.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/slide_in.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

late List<AnimationController> controllers;
late List<Animation<Offset>> animations;

final signinKey = GlobalKey<FormState>();

class _SigninScreenState extends State<SigninScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    controllers = List.generate(
      4,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );

    animations = controllers
        .map((c) => Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: c, curve: Curves.easeOut)))
        .toList();

    for (int i = 0; i < controllers.length - 1; i++) {
      controllers[i].addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controllers[i + 1].forward();
        }
      });
    }

    controllers.first.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: signinKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideIn(
                animation: animations[0],
                child: AuthField(
                  controller: TextEditingController(),
                  lable: "Email",
                  icon: Icons.email_outlined,
                  validator: Validation.validateEmail,
                ),
              ),
              const SizedBox(height: 15),
              SlideIn(
                animation: animations[1],
                child: AuthField(
                  controller: TextEditingController(),
                  lable: "Password",
                  icon: Icons.lock_outline,
                  validator: Validation.validatePassord,
                  obscureText: true,
                ),
              ),
              60.hBox,
              SigninButton(animation: animations[2], formKey: signinKey),
              40.hBox,
              DoHaveAccount(
                title: "you have not account",
                subtitle: "Create Account",
                onTap: () {
                  context.pop();
                  context.pushNamed(Routes.signupScreen);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
