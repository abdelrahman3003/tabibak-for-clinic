import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/usecase/get_doctor_use_case.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/manager/doctor_profile/doctor_profile_bloc.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/view/widget/doctor_profile_screen/doctor_profile_body.dart';

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoctorProfileBloc(getit<GetDoctorUseCase>()),
      child: Scaffold(
        body:
            SafeArea(child: BlocBuilder<DoctorProfileBloc, DoctorProfileState>(
          builder: (context, state) {
            if (state is DoctorProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is DoctorProfileFailed) {
              return Center(child: Text(state.errorMessage));
            }
            if (state is DoctorProfileSuccess) {
              final doctor = state.doctorEntity;
              return DoctorProfileBody(doctor: doctor);
            }

            return const SizedBox.shrink();
          },
        )),
      ),
    );
  }
}
