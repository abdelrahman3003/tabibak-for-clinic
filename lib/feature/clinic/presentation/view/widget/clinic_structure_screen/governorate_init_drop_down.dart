import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/auth_dropdown.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/governorate_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_info/clinic_info_bloc.dart';

class GovernorateInitDropDown extends StatefulWidget {
  const GovernorateInitDropDown({
    super.key,
    this.onChanged,
    this.initialValue,
  });

  final Function(GovernorateEntity?)? onChanged;
  final GovernorateEntity? initialValue;

  @override
  State<GovernorateInitDropDown> createState() =>
      _GovernorateInitDropDownState();
}

class _GovernorateInitDropDownState extends State<GovernorateInitDropDown> {
  GovernorateEntity? selectedGovernorate;

  @override
  void initState() {
    super.initState();
    selectedGovernorate = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClinicInfoBloc, ClinicInfoState>(
      buildWhen: (previous, current) => current is GetGovernoratesSuccess,
      builder: (context, state) {
        final List<GovernorateEntity> items =
            state is GetGovernoratesSuccess ? state.governorates : [];

        GovernorateEntity? actualSelected = selectedGovernorate;
        if (actualSelected != null && items.isNotEmpty) {
          try {
            actualSelected = items.firstWhere((item) => item.id == actualSelected!.id);
          } catch (_) {
            actualSelected = null;
          }
        }

        return AppDropdown<GovernorateEntity>(
          items: items,
          value: actualSelected,
          hint: AppString.governorate,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          labelBuilder: (item) =>
              Localizations.localeOf(context).languageCode == 'ar'
                  ? (item.nameAr ?? '')
                  : (item.nameEn ?? ''),
          validator: (value) =>
              value == null ? AppString.selectGovernorateValidator : null,
          onChanged: (value) {
            setState(() {
              selectedGovernorate = value;
            });
            widget.onChanged?.call(value);
          },
        );
      },
    );
  }
}
