import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_padding.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appointment_screen/appointment_empty.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appointment_screen/appointment_list.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appointment_screen/today_banner.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/schedule_screen/title_text_row.dart';

class AppointmentBody extends StatelessWidget {
  const AppointmentBody(
      {super.key, required this.appointmentList, required this.doctorName});
  final List<AppointmentEntity> appointmentList;
  final String doctorName;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
      child: Column(
        children: [
          TodayBanner(
            doctorName: doctorName,
            appointmentLength: appointmentList.length,
          ),
          32.hBox,
          TitleTextRow(
            title: AppString.appointmentsToday,
            subtitle: AppString.seeAll,
            onTap: () {
              context.pushNamed(Routes.allAppointmentScreen);
            },
          ),
          10.hBox,
          appointmentList.isEmpty
              ? Expanded(
                  child: AppointmentEmpty(title: AppString.noAppointmentsToday))
              : AppointmentList(
                  appointmentList: appointmentList,
                )
        ],
      ),
    );
  }
}
