import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appoinment_details_screen/detail_row.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appoinment_details_screen/section_card.dart';

class AppointmentInfoSection extends StatelessWidget {
  const AppointmentInfoSection({super.key, required this.entity});
  final AppointmentEntity entity;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final appointmentTypeDisplay = (isArabic
            ? entity.appointmentTypeAr
            : entity.appointmentTypeEn) ??
        entity.appointmentTypeAr ??
        entity.appointmentTypeEn ??
        '—';

    final isMorning = entity.appointmentMorningShiftId != null;
    final isEvening = entity.appointmentEveningShiftId != null;
    final shiftDisplay = isMorning
        ? 'Morning'.tr()
        : (isEvening
            ? 'Evening'.tr()
            : (isArabic ? 'صباحي' : 'Morning'));

    final shiftIcon = isMorning
        ? Icons.wb_sunny_outlined
        : (isEvening
            ? Icons.nights_stay_outlined
            : Icons.access_time_rounded);

    final shiftColor = isMorning
        ? const Color(0xFFF59E0B)
        : const Color(0xFF8B5CF6);

    return SectionCard(
      title: 'Appointment Info'.tr(),
      children: [
        DetailRow(
          icon: Icons.medical_services_outlined,
          label: 'Appointment Type'.tr(),
          value: appointmentTypeDisplay,
          iconColor: const Color(0xFF14B8A6),
        ),
        DetailRow(
          icon: Icons.calendar_today_rounded,
          label: 'Date'.tr(),
          value: _formatDate(entity.appointmentDate),
          iconColor: const Color(0xFF6366F1),
        ),
        DetailRow(
          icon: shiftIcon,
          label: 'Shift'.tr(),
          value: shiftDisplay,
          iconColor: shiftColor,
        ),
        DetailRow(
          icon: Icons.tag_rounded,
          label: 'Appointment ID'.tr(),
          value: '#${entity.appointmentId ?? '—'}',
          iconColor: const Color(0xFF14B8A6),
        ),
        if (entity.waitingList != null)
          DetailRow(
            icon: Icons.queue_rounded,
            label: AppString.waitingList,
            value: entity.waitingList == 0
                ? AppString.yourTurn
                : '${entity.waitingList}',
            iconColor: const Color(0xFFF59E0B),
          ),
      ],
    );
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '—';
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${dt.day} ${months[dt.month]} ${dt.year}';
  }
}
