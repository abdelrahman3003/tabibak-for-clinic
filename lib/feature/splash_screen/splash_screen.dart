import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/services/force_update_service.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart' show AppColors;
import 'package:tabibak_for_clinic/feature/auth/domain/usecases/get_doctor_auth_use_case.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/managers/splash/splash_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final updateInfo = await ForceUpdateService.checkForRequiredUpdate();
    if (updateInfo != null) {
      _showForceUpdateDialog(updateInfo);
      return;
    }

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

  void _showForceUpdateDialog(ForceUpdateInfo updateInfo) {
    if (!mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: Text(AppString.updateRequired),
          content: Text(AppString.updateRequiredMessage),
          actions: [
            TextButton(
              onPressed: () async {
                final uri = Uri.tryParse(updateInfo.storeUrl);
                if (uri != null && uri.hasScheme) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: Text(AppString.updateNow),
            ),
          ],
        ),
      ),
    );
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
            title: Text(AppString.noInternetConnection),
            content: Text(AppString.checkInternetConnection),
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
                child: Text(AppString.retry),
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
            title: Text(AppString.connectionError),
            content: Text(AppString.unableToConnectServer),
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
                child: Text(AppString.retry),
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
                  10.hBox,
                  Text(
                    "طبيبك ",
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
