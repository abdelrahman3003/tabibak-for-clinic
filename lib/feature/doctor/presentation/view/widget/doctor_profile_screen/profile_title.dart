import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';

class ProfileTitle extends StatelessWidget {
  const ProfileTitle({super.key, required this.title, required this.icon});
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: const Color(0xffE0E7FF),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: const Color(0xff475569))),
        10.wBox,
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18.sp,
              ),
        ),
      ],
    );
  }
}
