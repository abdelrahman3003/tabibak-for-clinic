import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tabibak_for_clinic/core/constatnt/app_svg.dart';
import 'package:tabibak_for_clinic/core/widgets/app_circle_indicator.dart';

class CustomSigninButton extends StatelessWidget {
  const CustomSigninButton(
      {super.key, required this.isLoading, this.onPressed});
  final bool isLoading;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.grey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: isLoading
            ? SizedBox.shrink()
            : SvgPicture.asset(AppSvg.googleIcon, height: 22.h, width: 22.w),
        label: isLoading
            ? AppCircleIndicator()
            : Text("Sign in with Google",
                style: Theme.of(context).textTheme.bodyLarge),
        onPressed: isLoading ? null : onPressed,
      ),
    );
  }
}
