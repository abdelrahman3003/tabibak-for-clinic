import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthSubtitleText extends StatelessWidget {
  const AuthSubtitleText({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(title,
        style:
            Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 18.sp));
  }
}
