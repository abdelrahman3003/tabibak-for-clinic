import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/managers/sign_up_bloc/signup_bloc.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/auth_dropdown.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/specialty_entity.dart';

class SpecailtiesDropdwon extends StatelessWidget {
  const SpecailtiesDropdwon({
    super.key,
    this.onChangedSpecialization,
  });

  final Function(int?)? onChangedSpecialization;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        final List<SpecialtyEntity> items =
            state is GetSpecialtiesRequestedSuccess ? state.specialties : [];

        return AppDropdown<SpecialtyEntity>(
          items: items,
          hint: "Select Specialty",
          labelBuilder: (item) => item.nameEn,
          validator: (value) =>
              value == null ? 'Please select a specialty' : null,
          onChanged: (value) {
            onChangedSpecialization?.call(value?.id);
          },
        );
      },
    );
  }
}
