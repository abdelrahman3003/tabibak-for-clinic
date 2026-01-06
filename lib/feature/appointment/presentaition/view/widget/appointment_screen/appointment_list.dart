import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_status_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/manager/appoinment/appointment_bloc.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/view/widget/appointment_screen/appointment_card.dart';

class AppointmentList extends StatelessWidget {
  const AppointmentList({
    super.key,
    required this.appointmentList,
    required this.appointmentStatusList,
  });
  final List<AppointmentEntity> appointmentList;
  final List<AppointmentStatusEntity> appointmentStatusList;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) => AppointmentCard(
        onStatusChanged: (value) {
          context.read<AppointmentBloc>().add(UpdateAppointmentStatusEvent(
              statusIndex: value,
              appointmentId: appointmentList[index].appointmentId!));
        },
        appointmentStatusLis: appointmentStatusList,
        appointmentEntity: appointmentList[index],
      ),
      separatorBuilder: (context, index) => 10.hBox,
      itemCount: appointmentList.length,
    );
  }
}
