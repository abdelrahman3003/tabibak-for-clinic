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
    return Expanded(
      child: GestureDetector(
          onTap: onTa,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: isActive
                    ? Theme.of(context).primaryColor
                    : Colors.transparent),
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: isActive ? AppColors.white : Colors.grey),
            ),
          )),
    );
  }
}
