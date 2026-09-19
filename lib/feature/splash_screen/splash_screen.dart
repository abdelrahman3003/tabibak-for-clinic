import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart' show AppColors;
import 'package:tabibak_for_clinic/feature/auth/domain/usecases/get_doctor_auth_use_case.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/managers/splash/splash_bloc.dart';

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
      if (!mounted) return;

      setState(() {
        opacity = 1;
      });

      Future.delayed(const Duration(milliseconds: 1200), () {});
    });
  }

  void _checkInitPage(SplashSuccess state, BuildContext context) {
    if (state.doctorEntity != null) {
      context.pushNamedAndRemoveUntil(
        Routes.layOutScreen,
        (_) => false,
      );
    } else {
      getit<Supabase>().client.auth.signOut();

      context.pushNamedAndRemoveUntil(
        Routes.signinScreen,
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc(
        getit<GetDoctorAuthUseCase>(),
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: BlocListener<SplashBloc, SplashState>(
          listener: (context, state) {
            if (state is SplashSuccess) {
              _checkInitPage(state, context);
            }
          },
          child: Center(
            child: AnimatedOpacity(
              opacity: opacity,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/images/splash.png",
                    color: AppColors.primary,
                    height: 150.h,
                    width: 250.w,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    " طبيبك",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
