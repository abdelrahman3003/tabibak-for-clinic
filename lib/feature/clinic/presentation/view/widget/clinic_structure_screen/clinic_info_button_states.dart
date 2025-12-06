import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/core/widgets/dialogs.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_info/clinic_info_bloc.dart';

class ClinicInfoButtonStates extends StatelessWidget {
  const ClinicInfoButtonStates({super.key, required this.clinicInfoEntity});
  final ClinicInfoEntity clinicInfoEntity;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClinicInfoBloc, ClinicInfoState>(
      listener: (context, state) {
        if (state is ClinicInfoFailed) {
          Dialogs.errorDialog(context, state.errorMEssage);
        } else if (state is ClinicInfoSuccess) {
          context.pushNamed(Routes.clinicDaysScreen);
        }
      },
      builder: (context, state) {
        return AppButton(
          title: "Continue",
          isLoading: state is ClinicInfoLoading,
          onPressed: () {
            context
                .read<ClinicInfoBloc>()
                .add(CreateClinicInfoEvent(clinicInfoEntity: clinicInfoEntity));
          },
        );
      },
    );
  }
}
