import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_widget.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/view/widget/appoinment_details_screen/appointment_details_item.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  const AppointmentDetailsScreen({super.key});

  Color getStatusColor(String s) {
    if (s == "pending") return Colors.orange;
    if (s == "confirmed") return Colors.green;
    if (s == "cancelled") return Colors.red;
    if (s == "finished") return Colors.blue;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    const patientName = "Mahmoud Ahmed";
    const date = "25 Nov 2025";
    const time = "3:00 PM";
    const reason = "General Checkup";

    return Scaffold(
      appBar: const AppBarWidget(title: "Appointment Details"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(Icons.person, size: 40, color: Colors.blue),
                ),
                16.wBox,
                Expanded(
                  child: Text(patientName,
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              ],
            ),
            25.hBox,
            const AppointmentDetailsItem(
                title: date, icon: Icons.calendar_today),
            14.hBox,
            const AppointmentDetailsItem(title: time, icon: Icons.access_time),
            14.hBox,
            const AppointmentDetailsItem(
                title: reason, icon: Icons.info_outline),
            20.hBox,
            _buildStatus(),
            const Spacer(),
            AppButton(
              title: "Cancel Appointment",
              color: AppColors.red,
              onPressed: () {},
            ),
            20.hBox,
          ],
        ),
      ),
    );
  }

  Container _buildStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        "Pending",
        style: TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}
