import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appoinment_details_screen/appointment_actions_buttons.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appoinment_details_screen/appointment_info_Section.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appoinment_details_screen/paient_card.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appoinment_details_screen/patien_info_section.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appoinment_details_screen/section_card.dart';

class AppointmentDetailsBody extends StatelessWidget {
  const AppointmentDetailsBody({
    super.key,
    required this.appointmentEntity,
    this.onComplete,
    this.onFollowUp,
    this.onCancel,
    this.isCompleteLoading = false,
    this.isFollowUpLoading = false,
    this.isCancelLoading = false,
  });

  final AppointmentEntity appointmentEntity;
  final VoidCallback? onComplete;
  final void Function(DateTime date)? onFollowUp;
  final VoidCallback? onCancel;
  final bool isCompleteLoading;
  final bool isFollowUpLoading;
  final bool isCancelLoading;

  @override
  Widget build(BuildContext context) {
    final e = appointmentEntity;
    final statusLabel = e.statusEn ?? '—';

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PatientCard(
              entity: e,
              statusLabel: statusLabel,
            ),
            24.hBox,
            AppointmentInfoSection(entity: e),
            16.hBox,
            PatientInfoSection(entity: e),
            if (e.description != null && e.description!.isNotEmpty) ...[
              16.hBox,
              SectionCard(
                title: 'Description',
                children: [
                  Text(
                    e.description!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ],
            32.hBox,
            if (e.statusId == 1 || e.statusId == 5)
              AppointmentActionButtons(
                isCompleteLoading: isCompleteLoading,
                isFollowUpLoading: isFollowUpLoading,
                isCancelLoading: isCancelLoading,
                onComplete: onComplete,
                onFollowUp: onFollowUp,
                onCancel: onCancel,
              ),
            20.hBox,
          ],
        ),
      ),
    );
  }
}
