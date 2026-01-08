import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/functions/format_time.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/core/widgets/image_circle.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_status_entity.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentEntity appointmentEntity;
  final List<AppointmentStatusEntity> appointmentStatusLis;
  final ValueChanged<int> onStatusChanged;

  const AppointmentCard({
    super.key,
    required this.onStatusChanged,
    required this.appointmentStatusLis,
    required this.appointmentEntity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Row(
        children: [
          ImageCircle(imageUrl: appointmentEntity.userImage),
          14.wBox,
          Expanded(
            child: _buildNameAndDate(),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _badgeColor(appointmentEntity.status!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _buildStatusMenu(context),
          ),
        ],
      ),
    );
  }

  Column _buildNameAndDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appointmentEntity.userName ?? "",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          formatDayMonth(appointmentEntity.appointmentDate.toString()),
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  PopupMenuButton<int> _buildStatusMenu(BuildContext context) {
    return PopupMenuButton<int>(
      color: Colors.white,
      onSelected: (id) {
        onStatusChanged(id);
      },
      itemBuilder: (context) => appointmentStatusLis
          .map(
            (e) => PopupMenuItem<int>(
              value: e.id!,
              child: Text(
                e.status ?? '',
                style: TextStyle(
                  color: _badgeColor(e.status!),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
          .toList(),
      child: Text(
        appointmentEntity.status ?? "",
        textAlign: TextAlign.center, // يضمن أن النص في المنتصف
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: AppColors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  Color _badgeColor(String status) {
    switch (status) {
      case "Upcoming":
        return Colors.orange;
      case "Finished":
        return Colors.green;
      case "Cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
