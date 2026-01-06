import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/functions/format_time.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
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

  Color _badgeColor(String status) {
    switch (status) {
      case 'Upcoming':
        return Colors.orange;
      case 'Finished':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.grey.shade100,
            backgroundImage: appointmentEntity.userImage == null
                ? null
                : CachedNetworkImageProvider(appointmentEntity.userImage!),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
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
            ),
          ),
          GestureDetector(
            onTap: () => _showStatusSheet(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _badgeColor(appointmentEntity.status!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                appointmentEntity.status ?? "",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showStatusSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children:
              appointmentStatusLis.map((e) => _statusItem(context, e)).toList(),
        );
      },
    );
  }

  Widget _statusItem(
    BuildContext context,
    AppointmentStatusEntity entity,
  ) {
    return ListTile(
      title: Text(
        entity.status ?? '',
        style: TextStyle(
          color: _badgeColor(entity.status ?? ''),
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () {
        context.pop();
        onStatusChanged(entity.id!);
      },
    );
  }
}
