import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/dialogs.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/widget/doctor_profile_screen/edit_item.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/widget/doctor_profile_screen/profile_title.dart';

class ClinicInfoSection extends StatelessWidget {
  const ClinicInfoSection({super.key, required this.clinicInfoEntity});
  final ClinicInfoEntity clinicInfoEntity;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ProfileTitle(
            title: "Clinic Information", icon: Icons.medical_services),
        15.hBox,
        EditItem(
          title: "Clinic Info",
          subtitle: clinicInfoEntity.clinicName ?? "Known Name",
          onTap: () {
            context.pushNamed(Routes.clinicInfoScreen,
                arguments: clinicInfoEntity);
          },
        ),
        15.hBox,
        EditItem(
          title: "Clinic Address",
          subtitle: clinicInfoEntity.address ?? "Address Not Available",
          onTap: () {
            context.pushNamed(Routes.clinicAddressScreen);
          },
        ),
        15.hBox,
        EditItem(
          title: "Clinic Offer",
          subtitle: "Known Offer",
          onTap: () {
            Dialogs.bottomSheet(context, title: "This Section no available");
            // context.pushNamed(Routes.clinicOfferScreen);
          },
        )
      ],
    );
  }
}
