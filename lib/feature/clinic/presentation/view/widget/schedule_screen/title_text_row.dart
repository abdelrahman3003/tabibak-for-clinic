import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/schedule_screen/title_text.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/view/widget/doctor_profile_screen/text_button_widget.dart';

class TitleTextRow extends StatelessWidget {
  const TitleTextRow(
      {super.key, required this.title, required this.subtitle, this.onTap});
  final String title;
  final String subtitle;
  final Function()? onTap;
  @override
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: TitleText(title: title)),
        TextButtonWidget(text: subtitle, onTap: onTap)
      ],
    );
  }
}
