import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_home_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/manager/appoinment/appointment_bloc.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/view/widget/appointment_screen/appointment_card.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/view/widget/appointment_screen/today_banner.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/schedule_screen/title_text_row.dart';

class AppointmentBody extends StatelessWidget {
  const AppointmentBody({super.key, required this.appointmentHomeEntity});
  final AppointmentHomeEntity appointmentHomeEntity;
  @override
  Widget build(BuildContext context) {
    final appointmentList = appointmentHomeEntity.appointmentList ?? [];
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
                  context.pushNamed(Routes.allAppointmentScreen);
                },
              ),
              10.hBox,
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) => AppointmentCard(
                  onStatusChanged: (value) {
                    context.read<AppointmentBloc>().add(
                        UpdateAppointmentStatusEvent(
                            statusIndex: value,
                            appointmentId:
                                appointmentList[index].appointmentId!));
                  },
                  appointmentStatusLis:
                      appointmentHomeEntity.appointmentStatusList ?? [],
                  name: appointmentList[index].userName ?? '',
                  date: appointmentList[index].appointmentDate.toString(),
                  status: appointmentList[index].status ?? '',
                  image: appointmentList[index].userImage ?? '',
                ),
                separatorBuilder: (context, index) => 10.hBox,
                itemCount: appointmentList.length,
              )
            ],
          ),
        )
      ],
    );
  }
}
