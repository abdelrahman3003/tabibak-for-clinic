import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';

class ItemBar extends StatelessWidget {
  const ItemBar(
      {super.key, required this.isActive, required this.text, this.onTa});
  final bool isActive;
  final String text;
  final Function()? onTa;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTa,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: isActive
                  ? Theme.of(context).primaryColor
                  : Colors.transparent),
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: isActive ? AppColors.white : Colors.grey),
          ),
        ));
  }
}
