import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/empty_widget.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_home_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/view/widget/appointment_screen/appointment_list.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/view/widget/appointment_screen/today_banner.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/schedule_screen/title_text_row.dart';

class AppointmentBody extends StatelessWidget {
  const AppointmentBody({super.key, required this.appointmentHomeEntity});
  final AppointmentHomeEntity appointmentHomeEntity;
  @override
  Widget build(BuildContext context) {
    final appointmentList = appointmentHomeEntity.appointmentTodayList ?? [];
    final appointmentStatusList =
        appointmentHomeEntity.appointmentStatusList ?? [];
    return Column(
      children: [
        TodayBanner(
          doctorName:
              getit<Supabase>().client.auth.currentUser?.userMetadata?['name'],
          appointmentLength: appointmentList.length,
        ),
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
                  Navigator.pushNamed(context, Routes.allAppointmentScreen,
                      arguments: appointmentStatusList);
                },
              ),
              10.hBox,
              appointmentList.isEmpty
                  ? const Center(
                      child: EmptyWidget(message: "No Appointments Today"))
                  : AppointmentList(
                      type: 1,
                      isToday: true,
                      appointmentList: appointmentList,
                      appointmentStatusList: appointmentStatusList)
            ],
          ),
        )
      ],
    );
  }
}
