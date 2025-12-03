import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/route_screen_wapper.dart';
import 'package:tabibak_for_clinic/feature/appointment/all_appointment_screen.dart';
import 'package:tabibak_for_clinic/feature/appointment/appointment_details_screen.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/usecases/get_specialties_usecase.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/usecases/sign_up_usecase.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/managers/sign_in_bloc/signin_bloc.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/managers/sign_up_bloc/signup_bloc.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/screens/professional_practice_license_screen.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/screens/signin_screen.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/screens/signup_screen.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/screens/clinic%20creation/clinic_days_screen.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/screens/clinic%20creation/clinic_shifts_time_screen.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/screens/clinic%20creation/clinic_structure_screen.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/screens/clinic%20details/clinic_address_screen.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/screens/clinic%20details/clinic_info_screen.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/screens/clinic%20details/clinic_offer_screen.dart';
import 'package:tabibak_for_clinic/feature/doctor/screens/doctor_education_screen.dart';
import 'package:tabibak_for_clinic/feature/doctor/screens/doctor_personal_info_screen.dart';
import 'package:tabibak_for_clinic/feature/doctor/screens/doctor_specialty_screen.dart';
import 'package:tabibak_for_clinic/feature/schedule/schedule_edit_screen.dart';

import '../../layout_screen.dart';

class AppRouter {
  static Route generateRoute(RouteSettings setting) {
    switch (setting.name) {
      //Auth
      case Routes.signinScreen:
        return _buildSlideRoute(BlocProvider(
            create: (context) => getit<SigninBloc>(),
            child: const RootScreenWrapper(child: SigninScreen())));
      case Routes.signupScreen:
        return _buildSlideRoute(
            BlocProvider(
              create: (context) => getit<SignupBloc>(),
              child: const SignupScreen(),
            ),
            settings: setting);
      case Routes.professionalLicenseScreen:
        return _buildSlideRoute(
            BlocProvider(
              create: (context) => SignupBloc(
                  signUpUsecase: getit<SignUpUsecase>(),
                  getSpecialtiesUsecase: getit<GetSpecialtiesUsecase>()),
              child: const ProfessionalLicenseScreen(),
            ),
            settings: setting);

      //layout
      case Routes.layOutScreen:
        return _buildSlideRoute(const RootScreenWrapper(child: LayoutScreen()));

      // schedule
      case Routes.scheduleEditScreen:
        return _buildSlideRoute(
            const RootScreenWrapper(child: ScheduleEditScreen()));

      // doctor info
      case Routes.doctorPersonalInfo:
        return _buildSlideRoute(
            const RootScreenWrapper(child: DoctorPersonalInfo()));
      case Routes.doctorSpecialtyScreen:
        return _buildSlideRoute(
            const RootScreenWrapper(child: DoctorSpecialtyScreen()));
      case Routes.doctorEducationScreen:
        return _buildSlideRoute(
            const RootScreenWrapper(child: DoctorEducationScreen()));

      //clinic
      case Routes.clinicInfoScreen:
        return _buildSlideRoute(
            const RootScreenWrapper(child: ClinicInfoScreen()));
      case Routes.clinicAddressScreen:
        return _buildSlideRoute(
            const RootScreenWrapper(child: ClinicAddressScreen()));
      case Routes.clinicOfferScreen:
        return _buildSlideRoute(
            const RootScreenWrapper(child: ClinicOfferScreen()));
      case Routes.clinicStructureScreen:
        return _buildSlideRoute(
            const RootScreenWrapper(child: ClinicStructureScreen()));
      case Routes.clinicDaysScreen:
        return _buildSlideRoute(
            const RootScreenWrapper(child: ClinicDaysScreen()));
      case Routes.clinicShiftsTimeScreen:
        return _buildSlideRoute(
            const RootScreenWrapper(child: ClinicShiftsTimeScreen()));
      //appointment
      case Routes.allAppointmentScreen:
        return _buildSlideRoute(
            const RootScreenWrapper(child: AllAppointmentScreen()));
      case Routes.appointmentDetailsScreen:
        return _buildSlideRoute(
            const RootScreenWrapper(child: AppointmentDetailsScreen()));
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
      settings: settings,
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
