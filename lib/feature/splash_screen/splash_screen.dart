import 'package:connectivity_plus/connectivity_plus.dart';
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
    });
  }

  Future<bool> _isOffline() async {
    final result = await Connectivity().checkConnectivity();
    return result.contains(ConnectivityResult.none);
  }

  Future<void> _checkInitPage(SplashSuccess state) async {
    if (state.doctorEntity != null) {
      _goTo(Routes.layOutScreen);
      return;
    }

    if (await _isOffline()) {
      _showNoInternetDialog(context);
      return;
    }

    await getit<Supabase>().client.auth.signOut();

    _goTo(Routes.signinScreen);
  }

  void _goTo(String route) {
    if (!mounted) return;

    context.pushNamedAndRemoveUntil(
      route,
      (_) => false,
    );
  }

  void _showNoInternetDialog(BuildContext blocContext) {
    if (!mounted) return;

    showDialog(
      context: blocContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: const Text(
              'لا يوجد اتصال بالإنترنت',
            ),
            content: const Text(
              'تأكد من اتصالك بالإنترنت وحاول مرة أخرى',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();

                  blocContext.read<SplashBloc>().add(
                        CheckDoctorEvent(
                          user: Supabase.instance.client.auth.currentUser,
                        ),
                      );
                },
                child: const Text(
                  'إعادة المحاولة',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showErrorDialog(BuildContext blocContext) {
    if (!mounted) return;

    showDialog(
      context: blocContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: const Text(
              'خطأ في الاتصال',
            ),
            content: const Text(
              'تعذر الاتصال بالخادم. تأكد من اتصالك بالإنترنت وحاول مرة أخرى.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();

                  blocContext.read<SplashBloc>().add(
                        CheckDoctorEvent(
                          user: Supabase.instance.client.auth.currentUser,
                        ),
                      );
                },
                child: const Text(
                  'إعادة المحاولة',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc(
        getit<GetDoctorAuthUseCase>(),
      )..add(
          CheckDoctorEvent(
            user: Supabase.instance.client.auth.currentUser,
          ),
        ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: BlocListener<SplashBloc, SplashState>(
          listener: (context, state) {
            if (state is SplashSuccess) {
              _checkInitPage(state);
            }

            if (state is SplashError) {
              _showErrorDialog(context);
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
                    'assets/images/splash.png',
                    color: AppColors.primary,
                    height: 150.h,
                    width: 250.w,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    ' طبيبك',
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
