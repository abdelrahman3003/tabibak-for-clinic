import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';

class AppointmentCard extends StatelessWidget {
  final String name;
  final String time;
  final String status;

  const AppointmentCard({
    super.key,
    required this.name,
    required this.time,
    required this.status,
  });

  Color getBadgeColor() {
    if (status == "today") return Colors.blue;
    if (status == "upcoming") return Colors.orange;
    if (status == "finished") return Colors.green;
    if (status == "cancelled") return Colors.red;
    return Colors.grey;
  }

  String getBadgeText() {
    if (status == "today") return "اليوم";
    if (status == "upcoming") return "قادم";
    if (status == "finished") return "مكتمل";
    if (status == "cancelled") return "ملغي";
    return "";
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
              backgroundColor: Colors.blue.shade100,
              child: const Icon(Icons.person, size: 28, color: Colors.blue),
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
                  Text(time,
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade700)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: getBadgeColor().withOpacity(.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                getBadgeText(),
                style: TextStyle(
                  color: getBadgeColor(),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
