import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/dialogs.dart';
import 'package:tabibak_for_clinic/feature/doctor/widget/doctor_profile_screen/edit_item.dart';

class ClinicInfoSection extends StatelessWidget {
  const ClinicInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EditItem(
          title: "Clinic Info",
          subtitle: "Healthy Heart Clinic",
          onTap: () {
            context.pushNamed(Routes.clinicInfoScreen);
          },
        ),
        15.hBox,
        EditItem(
          title: "Clinic Address",
          subtitle: "نجع حمادي",
          onTap: () {
            context.pushNamed(Routes.clinicAddressScreen);
          },
        ),
        15.hBox,
        EditItem(
          title: "Clinic Offer",
          subtitle: "Sat-Thu: 9:00 AM - 5:00 PM",
          onTap: () {
            Dialogs.bottomSheet(context, title: "No Offers Current");
            // context.pushNamed(Routes.clinicOfferScreen);
          },
        )
      ],
    );
  }
}
