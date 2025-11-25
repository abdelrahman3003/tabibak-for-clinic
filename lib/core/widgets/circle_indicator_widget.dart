import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';

class CircleIndicatorWidget extends StatelessWidget {
  const CircleIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            height: 24.h,
            width: 24.w,
            child: const CircularProgressIndicator(
              color: AppColors.primary,
            )));
  }
}
