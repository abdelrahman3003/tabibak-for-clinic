import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/routing/router.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final localizationDelegates = context.localizationDelegates;
    final supportedLocales = context.supportedLocales;

    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Tabibak For Clinic',
            theme: AppTheme.lightTheme,
            localizationsDelegates: localizationDelegates,
            supportedLocales: supportedLocales,
            locale: locale,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: Routes.splashScreen,
          );
        });
  }
}
