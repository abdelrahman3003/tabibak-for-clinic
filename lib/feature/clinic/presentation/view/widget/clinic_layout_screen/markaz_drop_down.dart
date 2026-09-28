import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/auth_dropdown.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/city_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_address/clinic_address_bloc.dart';

class MarkazDropDown extends StatefulWidget {
  const MarkazDropDown({
    super.key,
    this.onChanged,
    this.initialValue,
  });

  final Function(CityEntity?)? onChanged;
  final CityEntity? initialValue;

  @override
  State<MarkazDropDown> createState() => _MarkazDropDownState();
}

class _MarkazDropDownState extends State<MarkazDropDown> {
  CityEntity? selectedMarkaz;

  @override
  void initState() {
    super.initState();
    selectedMarkaz = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant MarkazDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialValue != oldWidget.initialValue) {
      selectedMarkaz = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClinicAddressBloc, ClinicAddressState>(
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
