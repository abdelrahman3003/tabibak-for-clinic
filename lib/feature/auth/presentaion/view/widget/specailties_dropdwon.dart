import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/specialty_entity.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/managers/signup/signup_bloc.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/auth_dropdown.dart';

class SpecailtiesDropdwon extends StatelessWidget {
  const SpecailtiesDropdwon({super.key, this.onChangedSpecialization});
  final Function(int?)? onChangedSpecialization;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        final items = state is GetSpecialtiesRequestedSuccess
            ? state.specialties
            : <SpecialtyEntity>[];
        return SpecialtyDropdown(
          items: items,
          onChanged: onChangedSpecialization,
        );
      },
    );
  }
}
