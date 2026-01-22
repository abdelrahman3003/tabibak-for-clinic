import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/view/widget/doctor_profile_screen/text_button_widget.dart';

class EditItem extends StatelessWidget {
  const EditItem(
      {super.key, required this.title, required this.subtitle, this.onTap});
  final String title;
  final String subtitle;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: const Color(0xff94A3B8),
                        fontWeight: FontWeight.w500)),
              ),
              TextButtonWidget(text: 'Edit', onTap: onTap)
            ],
          ),
          Text(
            subtitle,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
