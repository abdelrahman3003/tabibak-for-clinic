import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/usecases/get_specialties_usecase.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/usecases/sign_up_usecase.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/managers/signup/signup_bloc.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/screens/home_screen.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/screens/professional_practice_license_screen.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/screens/signin_screen.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/screens/signup_screen.dart';

class AppRouter {
  static Route generateRoute(RouteSettings setting) {
    switch (setting.name) {
      //Auth
      case Routes.singinScreen:
        return _buildSlideRoute(SigninScreen());
      case Routes.signupScreen:
        return _buildSlideRoute(
          BlocProvider(
            create: (context) => SignupBloc(
                signUpUsecase: getit<SignUpUsecase>(),
                getSpecialtiesUsecase: getit<GetSpecialtiesUsecase>()),
            child: SignupScreen(),
          ),
        );
      case Routes.professionalLinceseScreen:
        return _buildSlideRoute(
            BlocProvider(
              create: (context) => SignupBloc(
                  signUpUsecase: getit<SignUpUsecase>(),
                  getSpecialtiesUsecase: getit<GetSpecialtiesUsecase>()),
              child: ProfessionalPracticeLicenseScreen(),
            ),
            settings: setting);

      //Home
      case Routes.homeScreen:
        return _buildSlideRoute(HomeScreen());
      default:
        return _buildSlideRoute(
          Scaffold(
            body: Center(
              child: Text("No route defined for ${setting.name}"),
            ),
          ),
        );
    }
  }

  static PageRoute _buildSlideRoute(Widget page, {RouteSettings? settings}) {
    return PageRouteBuilder(
      settings: settings, // ✅ مهم جدًا علشان البيانات تتنقل
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        const begin = Offset(1, 0);
        const end = Offset.zero;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.ease));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
