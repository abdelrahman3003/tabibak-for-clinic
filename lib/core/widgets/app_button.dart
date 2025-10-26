import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.color,
    required this.title,
    this.onPressed,
    this.isLoading = false,
    this.padding,
    this.textColor,
  });

  final Color? color;
  final Color? textColor;
  final String title;
  final bool isLoading;
  final Function()? onPressed;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.r),
        ),
        padding: padding ?? const EdgeInsets.symmetric(vertical: 12),
        backgroundColor: onPressed == null
            ? Theme.of(context).colorScheme.secondary
            : (color ?? AppColors.primary),
        foregroundColor: AppColors.white,
      ),
      onPressed: onPressed,
      child: Stack(
        children: [
          Center(
            child: Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontSize: 18.sp, color: AppColors.white)),
          ),
          if (isLoading)
            Positioned(
              right: 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
