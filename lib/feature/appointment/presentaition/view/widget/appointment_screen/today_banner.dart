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
            children: [
              Expanded(
                child: Text(
                  doctorName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondary,
                  shape: BoxShape.circle,
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
          10.hBox,
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: "$appointmentLength ",
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
            date,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ],
      ),
    );
  }
}
