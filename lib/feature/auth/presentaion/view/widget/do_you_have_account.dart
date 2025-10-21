import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';

class DoHaveAccount extends StatelessWidget {
  const DoHaveAccount(
      {super.key, required this.title, required this.subtitle, this.onTap});
  final String title, subtitle;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: title,
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          TextSpan(
              text: subtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: 16.sp, color: AppColors.primary),
              recognizer: TapGestureRecognizer()..onTap = onTap),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
