import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/auth_dropdown.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/city_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_address/clinic_address_bloc.dart';

class CityDropDown extends StatelessWidget {
  const CityDropDown({
    super.key,
    this.onChangedAddress,
    this.initialValue,
  });

  final Function(CityEntity?)? onChangedAddress;
  final CityEntity? initialValue;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClinicAddressBloc, ClinicAddressState>(
      buildWhen: (previous, current) => current is GetCitiesSuccess,
      builder: (context, state) {
        final List<CityEntity> items =
            state is GetCitiesSuccess ? state.cities : [];

        return AppDropdown<CityEntity>(
          items: items,
          value: initialValue,
          hint: AppString.address,
          labelBuilder: (item) =>
              Localizations.localeOf(context).languageCode == 'ar'
                  ? (item.nameAr ?? '')
                  : (item.nameEn ?? ''),
          validator: (value) =>
              value == null ? AppString.selectAddressValidator : null,
          onChanged: (value) {
            onChangedAddress?.call(value);
          },
        );
      },
    );
  }
}
