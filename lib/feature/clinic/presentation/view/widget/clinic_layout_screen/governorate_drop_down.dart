import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/auth_dropdown.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/governorate_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_address/clinic_address_bloc.dart';

class GovernorateDropDown extends StatefulWidget {
  const GovernorateDropDown({
    super.key,
    this.onChanged,
    this.initialValue,
  });

  final Function(GovernorateEntity?)? onChanged;
  final GovernorateEntity? initialValue;

  @override
  State<GovernorateDropDown> createState() => _GovernorateDropDownState();
}

class _GovernorateDropDownState extends State<GovernorateDropDown> {
  GovernorateEntity? selectedGovernorate;

  @override
  void initState() {
    super.initState();
    selectedGovernorate = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant GovernorateDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialValue != oldWidget.initialValue) {
      selectedGovernorate = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClinicAddressBloc, ClinicAddressState>(
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
