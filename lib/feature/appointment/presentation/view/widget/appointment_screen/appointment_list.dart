import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_status_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/manager/appoinment/appointment_bloc.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appointment_screen/appointment_card.dart';

class AppointmentList extends StatelessWidget {
  const AppointmentList({
    super.key,
    required this.appointmentList,
    required this.appointmentStatusList,
    required this.type,
    this.isToday = false,
    this.showActions = false,
  });

  final List<AppointmentEntity> appointmentList;
  final List<AppointmentStatusEntity> appointmentStatusList;
  final int type;
  final bool isToday;

  /// When true, each card shows Approve / Reject buttons.
  /// When false, cards are read-only (status badge only).
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (context, index) => 10.hBox,
      itemCount: appointmentList.length,
      itemBuilder: (context, index) => AppointmentCard(
        showActions: showActions,
        onStatusChanged: showActions
            ? (value) {
                context.read<AppointmentBloc>().add(UpdateAppointmentStatusEvent(
                    statusIndex: value,
                    appointmentId: appointmentList[index].appointmentId ?? 0,
                    type: type,
                    isToday: isToday));
              }
            : null,
        appointmentStatusLis: appointmentStatusList,
        appointmentEntity: appointmentList[index],
      ),
    );
  }
}
