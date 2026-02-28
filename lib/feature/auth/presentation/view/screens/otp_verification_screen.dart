import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_widget.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/managers/verifiy_code_bloc/verify_code_bloc.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/otp_verified/otp_nodes.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/verify_code/verify_buttons_states.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key, required this.email});
  final String email;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _secondsRemaining = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsRemaining = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.hBox,
              Text(
                AppString.verifyCode,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
              ),
              12.hBox,
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textLight,
                        height: 1.5,
                      ),
                  children: [
                    TextSpan(text: AppString.enterCodeSentTo),
                    TextSpan(
                      text: widget.email,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              40.hBox,
              OtpNodes(controllers: _controllers, focusNodes: _focusNodes),
              30.hBox,
              Center(
                child: TextButton(
                  onPressed: _secondsRemaining == 0
                      ? () {
                          _startTimer();
                          context
                              .read<VerifyCodeBloc>()
                              .add(ResendOtp(email: widget.email));
                        }
                      : null,
                  child: Text(
                    _secondsRemaining > 0
                        ? "${AppString.resendAfter} $_secondsRemaining ${AppString.seconds}"
                        : AppString.resendCode,
                    style: TextStyle(
                      color: _secondsRemaining > 0
                          ? Colors.grey
                          : AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
              40.hBox,
              VerifyButtonsStates(
                email: widget.email,
                focusNodes: _focusNodes,
                controllers: _controllers,
              )
            ],
          ),
        ),
      ),
    );
  }
}
