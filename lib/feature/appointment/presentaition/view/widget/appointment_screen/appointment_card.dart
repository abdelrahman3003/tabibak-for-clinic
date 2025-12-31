import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/functions/format_time.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';

class AppointmentCard extends StatelessWidget {
  final String name;
  final String date;
  final String status;
  final String? image;

  const AppointmentCard({
    super.key,
    required this.name,
    required this.image,
    required this.status,
    required this.date,
  });

  Color getBadgeColor() {
    if (status == "Upcoming") return Colors.orange;
    if (status == "Finished") return Colors.green;
    if (status == "Cancelled") return Colors.red;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(Routes.appointmentDetailsScreen);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.grey.shade100,
              backgroundImage:
                  image == null ? null : CachedNetworkImageProvider(image!),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(formatDayMonth(date),
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade700)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: getBadgeColor(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(status,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: AppColors.white)),
            )
          ],
        ),
      ),
    );
  }
}
