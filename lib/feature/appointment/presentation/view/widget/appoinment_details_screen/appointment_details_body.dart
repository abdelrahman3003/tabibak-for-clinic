import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appoinment_details_screen/appointment_actions_buttons_states.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appoinment_details_screen/appointment_info_section.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appoinment_details_screen/paient_card.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appoinment_details_screen/patien_info_section.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appoinment_details_screen/section_card.dart';

class AppointmentDetailsBody extends StatelessWidget {
  const AppointmentDetailsBody({
    super.key,
    required this.appointmentEntity,
  });

  final AppointmentEntity appointmentEntity;

  @override
  Widget build(BuildContext context) {
    final e = appointmentEntity;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PatientCard(
              entity: e,
              statusLabel: (context.locale.languageCode == 'ar'
                      ? e.statusAr
                      : e.statusEn) ??
                  '—',
            ),
            24.hBox,
            AppointmentInfoSection(entity: e),
            16.hBox,
            PatientInfoSection(entity: e),
            if (e.description != null && e.description!.isNotEmpty) ...[
              16.hBox,
              SectionCard(
                title: 'Description'.tr(),
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
            24.hBox,
            if (e.followUpDate != null) ...[
              16.hBox,
              SectionCard(
                title: 'Follow Up Date'.tr(),
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.event_repeat_rounded,
                        size: 18,
                        color: Color(0xFF6366F1),
                      ),
                      8.wBox,
                      Text(
                        e.followUpDate.toString().split(' ').first,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
            32.hBox,
            if (e.statusId == 5)
              AppointmentActionsButtonsStates(appointmentId: e.appointmentId!),
            20.hBox,
          ],
        ),
      ),
    );
  }
}
