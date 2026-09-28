import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/auth_dropdown.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/city_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_info/clinic_info_bloc.dart';

class MarkazInitDropDown extends StatefulWidget {
  const MarkazInitDropDown({
    super.key,
    this.onChanged,
    this.initialValue,
  });

  final Function(CityEntity?)? onChanged;
  final CityEntity? initialValue;

  @override
  State<MarkazInitDropDown> createState() => _MarkazInitDropDownState();
}

class _MarkazInitDropDownState extends State<MarkazInitDropDown> {
  CityEntity? selectedMarkaz;

  @override
  void initState() {
    super.initState();
    selectedMarkaz = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClinicInfoBloc, ClinicInfoState>(
      buildWhen: (previous, current) => current is GetMarkazSuccess,
      builder: (context, state) {
        final List<CityEntity> items =
            state is GetMarkazSuccess ? state.cities : [];

        CityEntity? actualSelected = selectedMarkaz;
        if (actualSelected != null && items.isNotEmpty) {
          try {
            actualSelected = items.firstWhere((item) => item.id == actualSelected!.id);
          } catch (_) {
            actualSelected = null;
          }
        }

        return AppDropdown<CityEntity>(
          items: items,
          value: actualSelected,
          hint: AppString.markaz,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          labelBuilder: (item) =>
              Localizations.localeOf(context).languageCode == 'ar'
                  ? (item.nameAr ?? '')
                  : (item.nameEn ?? ''),
          validator: (value) =>
              value == null ? AppString.selectMarkazValidator : null,
          onChanged: (value) {
            setState(() {
              selectedMarkaz = value;
            });
            widget.onChanged?.call(value);
          },
        );
      },
    );
  }
}
