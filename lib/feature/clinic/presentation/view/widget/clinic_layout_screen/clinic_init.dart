import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';

class ClinicInit extends StatelessWidget {
  const ClinicInit({
    super.key,
    this.title,
    this.message,
    this.buttonTitle,
    this.icon,
  });

  final String? title;
  final String? message;
  final String? buttonTitle;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final effectiveTitle = title ?? AppString.setupYourClinic;
    final effectiveMessage = message ?? AppString.setupClinicSubtitle;
    final effectiveButtonTitle = buttonTitle ?? AppString.addClinic;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 16.h),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.12),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              const BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildIconBadge(),
              24.hBox,
              if (effectiveTitle.isNotEmpty) ...[
                Text(
                  effectiveTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff1E293B),
                  ),
                ),
                12.hBox,
              ],
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  effectiveMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize:
                        effectiveTitle.isNotEmpty ? 14.sp : 16.sp,
                    fontWeight: effectiveTitle.isNotEmpty
                        ? FontWeight.normal
                        : FontWeight.w600,
                    color: effectiveTitle.isNotEmpty
                        ? const Color(0xff64748B)
                        : const Color(0xff1E293B),
                    height: 1.5,
                  ),
                ),
              ),
              28.hBox,
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.pushNamed(Routes.clinicStructureScreen);
                  },
                  icon: const Icon(Icons.add_rounded, color: Colors.white),
                  label: Text(
                    effectiveButtonTitle,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconBadge() {
    return Container(
      width: 96.w,
      height: 96.h,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryLight,
      ),
      child: Center(
        child: Container(
          width: 74.w,
          height: 74.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.15),
          ),
          child: Icon(
            icon ?? Icons.analytics_outlined,
            size: 40.sp,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
