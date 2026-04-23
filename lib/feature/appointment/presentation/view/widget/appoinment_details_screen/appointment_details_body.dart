import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appoinment_details_screen/appointment_details_cancel_button_states.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appoinment_details_screen/detail_row.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appoinment_details_screen/paient_card.dart';
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
    final statusColor = _statusColor(e.statusId);
    final statusLabel = e.statusEn ?? '—';

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PatientCard(
              entity: e,
              statusColor: statusColor,
              statusLabel: statusLabel,
              statusIcon: _statusIcon(e.statusId),
            ),
            24.hBox,
            SectionCard(
              title: 'Appointment Info',
              children: [
                DetailRow(
                  icon: Icons.calendar_today_rounded,
                  label: 'Date',
                  value: _formatDate(e.appointmentDate),
                  iconColor: const Color(0xFF6366F1),
                ),
                DetailRow(
                  icon: _shiftIcon(e.appointmentShift),
                  label: 'Shift',
                  value: _shiftLabel(e.appointmentShift),
                  iconColor: e.appointmentShift == 1
                      ? const Color(0xFFF59E0B)
                      : const Color(0xFF8B5CF6),
                ),
                DetailRow(
                  icon: Icons.tag_rounded,
                  label: 'Appointment ID',
                  value: '#${e.appointmentId ?? '—'}',
                  iconColor: const Color(0xFF14B8A6),
                ),
              ],
            ),
            16.hBox,
            SectionCard(
              title: 'Patient Info',
              children: [
                DetailRow(
                  icon: Icons.person_outline_rounded,
                  label: 'Name',
                  value: e.name ?? '—',
                  iconColor: const Color(0xFF10B981),
                ),
                DetailRow(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: e.phone ?? '—',
                  iconColor: const Color(0xFF6366F1),
                ),
                DetailRow(
                  icon: Icons.fingerprint_rounded,
                  label: 'User ID',
                  value: e.userId ?? '—',
                  iconColor: const Color(0xFFF59E0B),
                ),
              ],
            ),
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
              AppointmentDetailsCancelButtonStates(
                  appointmentId:
                      e.appointmentId!), // Pass the appointment ID here
            20.hBox,
          ],
        ),
      ),
    );
  }

  // ───────────────────────── Helpers ─────────────────────────

  Color _statusColor(int? id) {
    switch (id) {
      case 1:
        return const Color(0xFFF59E0B);
      case 2:
        return const Color(0xFF10B981);
      case 3:
        return const Color(0xFFEF4444);
      case 4:
        return const Color(0xFF3B82F6);
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(int? id) {
    switch (id) {
      case 1:
        return Icons.hourglass_empty_rounded;
      case 2:
        return Icons.check_circle_outline_rounded;
      case 3:
        return Icons.cancel_outlined;
      case 4:
        return Icons.task_alt_rounded;
      default:
        return Icons.info_outline;
    }
  }

  String _shiftLabel(int? shift) {
    switch (shift) {
      case 1:
        return 'Morning';
      case 2:
        return 'Evening';
      default:
        return '—';
    }
  }

  IconData _shiftIcon(int? shift) =>
      shift == 1 ? Icons.wb_sunny_outlined : Icons.nights_stay_outlined;

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
