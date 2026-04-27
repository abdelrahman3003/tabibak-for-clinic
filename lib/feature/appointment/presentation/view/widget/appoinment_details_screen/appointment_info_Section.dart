import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appoinment_details_screen/detail_row.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appoinment_details_screen/section_card.dart';

class AppointmentInfoSection extends StatelessWidget {
  const AppointmentInfoSection({super.key, required this.entity});
  final AppointmentEntity entity;
  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Appointment Info'.tr(),
      children: [
        DetailRow(
          icon: Icons.calendar_today_rounded,
          label: 'Date'.tr(),
          value: _formatDate(entity.appointmentDate),
          iconColor: const Color(0xFF6366F1),
        ),
        DetailRow(
          icon: entity.appointmentMorningShiftId != null
              ? _shiftIcon(entity.appointmentMorningShiftId)
              : _shiftIcon(entity.appointmentEveningShiftId),
          label: 'Shift'.tr(),
          value: entity.appointmentMorningShiftId != null
              ? _shiftLabel(entity.appointmentMorningShiftId)
              : _shiftLabel(entity.appointmentEveningShiftId),
          iconColor: entity.appointmentMorningShiftId != null &&
                  entity.appointmentMorningShiftId == 1
              ? const Color(0xFFF59E0B)
              : const Color(0xFF8B5CF6),
        ),
        DetailRow(
          icon: Icons.tag_rounded,
          label: 'Appointment ID'.tr(),
          value: '#${entity.appointmentId ?? '—'}',
          iconColor: const Color(0xFF14B8A6),
        ),
      ],
    );
  }

  String _shiftLabel(int? shift) {
    switch (shift) {
      case 1:
        return 'Morning'.tr();
      case 2:
        return 'Evening'.tr();
      default:
        return '—';
    }
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

  IconData _shiftIcon(int? shift) =>
      shift == 1 ? Icons.wb_sunny_outlined : Icons.nights_stay_outlined;
}
