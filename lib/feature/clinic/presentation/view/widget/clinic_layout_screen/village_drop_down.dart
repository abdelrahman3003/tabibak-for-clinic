import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/auth_dropdown.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/city_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_address/clinic_address_bloc.dart';

class VillageDropDown extends StatefulWidget {
  const VillageDropDown({
    super.key,
    this.onChanged,
    this.initialValue,
  });

  final Function(CityEntity?)? onChanged;
  final CityEntity? initialValue;

  @override
  State<VillageDropDown> createState() => _VillageDropDownState();
}

class _VillageDropDownState extends State<VillageDropDown> {
  CityEntity? selectedVillage;

  @override
  void initState() {
    super.initState();
    selectedVillage = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant VillageDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialValue != oldWidget.initialValue) {
      selectedVillage = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClinicAddressBloc, ClinicAddressState>(
      buildWhen: (previous, current) => current is GetVillagesSuccess,
      builder: (context, state) {
        final List<CityEntity> items =
            state is GetVillagesSuccess ? state.cities : [];

        CityEntity? actualSelected = selectedVillage;
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
          hint: AppString.village,
          labelBuilder: (item) =>
              Localizations.localeOf(context).languageCode == 'ar'
                  ? (item.nameAr ?? '')
                  : (item.nameEn ?? ''),
          onChanged: (value) {
            setState(() {
              selectedVillage = value;
            });

            widget.onChanged?.call(value);
          },
        );
      },
    );
  }
}
