import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/dialogs.dart';
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
          subtitle: clinicInfoEntity.address?.clinicAddress ??
              AppString.addressNotAvailable,
          onTap: () {
            context.pushNamed(Routes.clinicAddressScreen,
                arguments: clinicInfoEntity);
          },
        ),
        15.hBox,
        EditItem(
          title: AppString.clinicOffer,
          subtitle: AppString.knownOffer,
          onTap: () {
            Dialogs.noticeDialog(context,
                title: AppString.featureUnavailableMessage);
            // context.pushNamed(Routes.clinicOfferScreen);
          },
        )
      ],
    );
  }
}
