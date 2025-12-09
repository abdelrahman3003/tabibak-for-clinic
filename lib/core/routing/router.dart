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
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_creation/clinic_info/clinic_info_bloc.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_creation/clinic_shift/clinic_shift_bloc.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_creation/clinic_working_day/clinic_working_day_bloc.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/screens/clinic%20creation/clinic_days_screen.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/screens/clinic%20creation/clinic_shifts_time_screen.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/screens/clinic%20creation/clinic_structure_screen.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/screens/clinic%20details/clinic_address_screen.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/screens/clinic%20details/clinic_info_screen.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/screens/clinic%20details/clinic_offer_screen.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/screens/clinic%20schedule/schedule_edit_screen.dart';
import 'package:tabibak_for_clinic/feature/doctor/screens/doctor_education_screen.dart';
import 'package:tabibak_for_clinic/feature/doctor/screens/doctor_personal_info_screen.dart';
import 'package:tabibak_for_clinic/feature/doctor/screens/doctor_specialty_screen.dart';

import '../../layout_screen.dart';

class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    Widget page;

    switch (settings.name) {
      //Auth
      case Routes.signinScreen:
        page = BlocProvider(
          create: (context) => getit<SigninBloc>(),
          child: const RootScreenWrapper(child: SigninScreen()),
        );
        break;

      case Routes.signupScreen:
        page = BlocProvider(
          create: (context) => getit<SignupBloc>(),
          child: const SignupScreen(),
        );
        break;

      case Routes.professionalLicenseScreen:
        page = BlocProvider(
          create: (context) => SignupBloc(
            signUpUsecase: getit<SignUpUsecase>(),
            getSpecialtiesUsecase: getit<GetSpecialtiesUsecase>(),
          ),
          child: const ProfessionalLicenseScreen(),
        );
        break;

      //layout
      case Routes.layOutScreen:
        page = const RootScreenWrapper(child: LayoutScreen());
        break;

      // schedule
      case Routes.scheduleEditScreen:
        page = const RootScreenWrapper(child: ScheduleEditScreen());
        break;

      // doctor info
      case Routes.doctorPersonalInfo:
        page = const RootScreenWrapper(child: DoctorPersonalInfo());
        break;

      case Routes.doctorSpecialtyScreen:
        page = const RootScreenWrapper(child: DoctorSpecialtyScreen());
        break;

      case Routes.doctorEducationScreen:
        page = const RootScreenWrapper(child: DoctorEducationScreen());
        break;

      //clinic
      case Routes.clinicInfoScreen:
        page = const RootScreenWrapper(child: ClinicInfoScreen());
        break;

      case Routes.clinicAddressScreen:
        page = const RootScreenWrapper(child: ClinicAddressScreen());
        break;

      case Routes.clinicOfferScreen:
        page = const RootScreenWrapper(child: ClinicOfferScreen());
        break;

      case Routes.clinicStructureScreen:
        page = RootScreenWrapper(
          child: BlocProvider(
            create: (context) => getit<ClinicInfoBloc>(),
            child: const ClinicStructureScreen(),
          ),
        );
        break;

      case Routes.clinicDaysScreen:
        page = RootScreenWrapper(
          child: BlocProvider(
            create: (context) => getit<ClinicWorkingDayBloc>(),
            child: const ClinicDaysScreen(),
          ),
        );
        break;

      case Routes.clinicShiftsTimeScreen:
        page = RootScreenWrapper(
          child: BlocProvider(
            create: (context) => getit<ClinicShiftBloc>(),
            child: const ClinicShiftsTimeScreen(),
          ),
        );
        break;

      //appointment
      case Routes.allAppointmentScreen:
        page = const RootScreenWrapper(child: AllAppointmentScreen());
        break;

      case Routes.appointmentDetailsScreen:
        page = const RootScreenWrapper(child: AppointmentDetailsScreen());
        break;

      default:
        page = Scaffold(
          body: Center(
            child: Text("No route defined for ${settings.name}"),
          ),
        );
    }

    return _buildSlideRoute(page, settings);
  }

  static PageRoute _buildSlideRoute(Widget page, RouteSettings settings) {
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
