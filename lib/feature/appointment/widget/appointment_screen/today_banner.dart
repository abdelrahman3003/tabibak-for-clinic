import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';

class TodayBanner extends StatelessWidget {
  final int count;

  const TodayBanner({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayName = _getArabicDay(now.weekday);
    final date = DateFormat('d MMM yyyy').format(now);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Appointments Today",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            "$count Appointments",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          12.hBox,
          Row(
            children: [
              Icon(Icons.calendar_today,
                  color: Colors.white.withOpacity(.9), size: 18),
              const SizedBox(width: 6),
              Text(
                "$dayName - $date",
                style: TextStyle(
                  color: Colors.white.withOpacity(.95),
                  fontSize: 15,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  String _getArabicDay(int weekday) {
    switch (weekday) {
      case 1:
        return "الاثنين";
      case 2:
        return "الثلاثاء";
      case 3:
        return "الأربعاء";
      case 4:
        return "الخميس";
      case 5:
        return "الجمعة";
      case 6:
        return "السبت";
      case 7:
        return "الأحد";
      default:
        return "";
    }
  }
}
