import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';

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
      decoration: const BoxDecoration(
        color: AppColors.second,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 20,
                child: Icon(Icons.person),
              ),
              8.wBox,
              Text(
                "DR.Abdelrahman Temsah",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          10.hBox,
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: "$count ",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            TextSpan(
                text: "Appointments",
                style: Theme.of(context).textTheme.titleLarge)
          ])),
          5.hBox,
          Text(
            "$dayName - $date",
            style: Theme.of(context).textTheme.bodyMedium,
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
