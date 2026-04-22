import 'package:flutter/widgets.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appointment_screen/appointment_card.dart';

class AppointmentList extends StatelessWidget {
  const AppointmentList({
    super.key,
    required this.appointmentList,
    this.showActions = false,
    this.onStatusChanged,
  });

  final List<AppointmentEntity> appointmentList;
  final bool showActions;
  final void Function(int? appointmentId, int? statusIndex)? onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (context, index) => 10.hBox,
      itemCount: appointmentList.length,
      itemBuilder: (context, index) {
        final appointment = appointmentList[index];
        return AppointmentCard(
          showActions: showActions,
          appointmentEntity: appointment,
          onApprove: onStatusChanged != null
              ? () => onStatusChanged!(
                  appointment.appointmentId, 5) // 4 for Confirmed?
              : null,
          onReject: onStatusChanged != null
              ? () => onStatusChanged!(
                  appointment.appointmentId, 3) // 1 for Canceled
              : null,
        );
      },
    );
  }
}
