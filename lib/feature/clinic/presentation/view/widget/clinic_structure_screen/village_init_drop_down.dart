import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/auth_dropdown.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/city_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_info/clinic_info_bloc.dart';

class VillageInitDropDown extends StatefulWidget {
  const VillageInitDropDown({
    super.key,
    this.onChanged,
    this.initialValue,
  });

  final Function(CityEntity?)? onChanged;
  final CityEntity? initialValue;

  @override
  State<VillageInitDropDown> createState() => _VillageInitDropDownState();
}

class _VillageInitDropDownState extends State<VillageInitDropDown> {
  CityEntity? selectedVillage;

  @override
  void initState() {
    super.initState();
    selectedVillage = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClinicInfoBloc, ClinicInfoState>(
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
