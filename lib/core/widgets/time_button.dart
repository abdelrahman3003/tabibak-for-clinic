import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimeButton extends StatelessWidget {
  const TimeButton(
      {super.key, required this.title, this.time, required this.onTap});
  final String title;
  final TimeOfDay? time;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      ),
      child: Text(
        time == null ? title : time!.format(context),
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
