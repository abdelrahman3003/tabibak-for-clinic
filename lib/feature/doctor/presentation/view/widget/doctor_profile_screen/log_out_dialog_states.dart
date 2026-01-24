import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/core/widgets/dialogs.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/manager/doctor_profile/doctor_profile_bloc.dart';

class LogOutDialogStates extends StatelessWidget {
  const LogOutDialogStates({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getit.call<DoctorProfileBloc>(),
      child: BlocListener<DoctorProfileBloc, DoctorProfileState>(
        listener: (context, state) {
          if (state is LogOutDoctorSuccess) {
            context.pushNamedAndRemoveUntil(
              Routes.signinScreen,
              (_) => false,
            );
          }
          if (state is LogOutDoctorFailed) {
            Dialogs.errorDialog(context, state.errorMessage);
          }
        },
        child: BlocBuilder<DoctorProfileBloc, DoctorProfileState>(
          buildWhen: (previous, current) =>
              current is LogOutDoctorLoading || current is LogOutDoctorSuccess,
          builder: (context, state) {
            return Dialogs.alertDialog(
              context: context,
              title: "Log Out",
              subtitle: "Are you sure you want to log out?",
              confirmString: "Log Out",
              color: AppColors.red,
              isLoading: state is LogOutDoctorLoading,
              onPressed: () {
                context.read<DoctorProfileBloc>().add(LogOutDoctorEvent());
              },
            );
          },
        ),
      ),
    );
  }
}
