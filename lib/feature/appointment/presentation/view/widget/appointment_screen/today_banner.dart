import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';

class TodayBanner extends StatelessWidget {
  final String doctorName;
  final int appointmentLength;

  const TodayBanner(
      {super.key, required this.appointmentLength, required this.doctorName});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final date = DateFormat('d MMM yyyy').format(now);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: const Color(0xffE9E7FF),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: AppColors.grey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello,",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    Text(doctorName,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  onPressed: () {
                    context.pushNamed(Routes.addAppointmentScreen);
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          28.hBox,
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: "$appointmentLength ",
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            TextSpan(
                text: "Appointments",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w400, height: 18 / 28))
          ])),
          Text(date, style: Theme.of(context).textTheme.titleSmall)
        ],
      ),
    );
  }
}
