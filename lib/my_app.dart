import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/routing/router.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Tabibak For Clinic',
              theme: AppTheme.lightTheme,
              // localizationsDelegates: context.localizationDelegates,
              // supportedLocales: context.supportedLocales,
              // locale: context.locale,
              onGenerateRoute: AppRouter.generateRoute,
              initialRoute: Routes.signupScreen);
        });
  }
}
