import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appoinment_details_screen/detail_row.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appoinment_details_screen/section_card.dart';

class PatientInfoSection extends StatelessWidget {
  const PatientInfoSection({super.key, required this.entity});
  final AppointmentEntity entity;
  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Patient Info',
      children: [
        DetailRow(
          icon: Icons.person_outline_rounded,
          label: 'Name',
          value: entity.name ?? '—',
          iconColor: const Color(0xFF10B981),
        ),
        DetailRow(
          icon: Icons.phone_outlined,
          label: 'Phone',
          value: entity.phone ?? '—',
          iconColor: const Color(0xFF6366F1),
        ),
        DetailRow(
          icon: Icons.fingerprint_rounded,
          label: 'User ID',
          value: entity.userId ?? '—',
          iconColor: const Color(0xFFF59E0B),
        ),
      ],
    );
  }
}
