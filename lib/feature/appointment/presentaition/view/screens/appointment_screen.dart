import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/view/widget/appointment_screen/appointment_card.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/view/widget/appointment_screen/today_banner.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/schedule_screen/title_text_row.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TodayBanner(count: 5),
        20.hBox,
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
          child: Column(
            children: [
              TitleTextRow(
                title: "Appointments's Today",
                subtitle: "See All",
                onTap: () {
                  context.pushNamed(Routes.allAppointmentScreen);
                },
              ),
              10.hBox,
              const AppointmentCard(
                  name: "Abdelrahman Temsah", time: "time", status: "upcoming")
            ],
          ),
        )
      ],
    );
  }
}
