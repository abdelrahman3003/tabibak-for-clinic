import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/view/widget/doctor_profile_screen/edit_item.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/view/widget/doctor_profile_screen/profile_title.dart';

class ClinicInfoSection extends StatelessWidget {
  const ClinicInfoSection({super.key, required this.clinicInfoEntity});
  final ClinicInfoEntity clinicInfoEntity;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileTitle(
            title: AppString.clinicInformation, icon: Icons.medical_services),
        15.hBox,
        EditItem(
          title: AppString.clinicInformation,
          subtitle: clinicInfoEntity.clinicName ?? AppString.knownName,
          onTap: () {
            context.pushNamed(Routes.clinicInfoScreen,
                arguments: clinicInfoEntity);
          },
        ),
        15.hBox,
        EditItem(
          title: AppString.clinicAddress,
          subtitle: _formatAddress(context),
          onTap: () {
            context.pushNamed(Routes.clinicAddressScreen,
                arguments: clinicInfoEntity);
          },
        ),
        15.hBox,
        EditItem(
          title: AppString.clinicOffer,
          subtitle: AppString.manageClinicOffer,
          onTap: () {
            context.pushNamed(Routes.clinicOfferScreen,
                arguments: clinicInfoEntity);
          },
        ),
        15.hBox,
        EditItem(
          title: AppString.doctorServices,
          subtitle: AppString.manageDoctorServices,
          onTap: () {
            context.pushNamed(Routes.doctorServicesScreen,
                arguments: clinicInfoEntity);
          },
        ),
      ],
    );
  }

  String _formatAddress(BuildContext context) {
    final isEn = context.locale.languageCode == "en";
    final addr = clinicInfoEntity.address;
    if (addr == null) return AppString.addressNotAvailable;

    final parts = <String>[];
    final govName = isEn ? addr.governorate?.nameEn : addr.governorate?.nameAr;
    final markazName = isEn ? addr.markaz?.nameEn : addr.markaz?.nameAr;
    final villageName = isEn ? addr.village?.nameEn : addr.village?.nameAr;
    final street = addr.street ?? addr.clinicAddress;

    if (govName != null && govName.trim().isNotEmpty) parts.add(govName.trim());
    if (markazName != null && markazName.trim().isNotEmpty) parts.add(markazName.trim());
    if (villageName != null && villageName.trim().isNotEmpty) parts.add(villageName.trim());
    if (street != null && street.trim().isNotEmpty) parts.add(street.trim());

    if (parts.isEmpty) {
      return AppString.addressNotAvailable;
    }

    return parts.join(' - ');
  }
}
