import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/helper/shared_pref_helper.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart' show AppColors;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacity = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        opacity = 1;
      });
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (getit<SharedPrefHelper>().getInt(SharedPrefKeys.step) == 2) {
          return context.pushNamedAndRemoveUntil(
            Routes.layOutScreen,
            (route) => true,
          );
        }
        return context.pushNamedAndRemoveUntil(
          Routes.signinScreen,
          (route) => true,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: AnimatedOpacity(
          opacity: opacity,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/app_logo.png",
                color: AppColors.primary,
                height: 180,
                width: 350.w,
                fit: BoxFit.cover,
              ),
              Text(
                "طبيبك",
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontFamily: "Inter",
                      color: AppColors.primary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
