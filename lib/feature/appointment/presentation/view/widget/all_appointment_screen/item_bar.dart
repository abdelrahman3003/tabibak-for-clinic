import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';

class ItemBar extends StatelessWidget {
  const ItemBar({
    super.key,
    required this.isActive,
    required this.text,
    this.onTa,
    this.activeColor,
    this.activeTextColor = AppColors.white,
  });

  final bool isActive;
  final String text;
  final Function()? onTa;
  final Color? activeColor;
  final Color activeTextColor;

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? Theme.of(context).primaryColor;

    return Expanded(
      child: GestureDetector(
        onTap: onTa,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: isActive ? effectiveActiveColor : Colors.transparent,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: effectiveActiveColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                  color: isActive ? activeTextColor : Colors.grey.shade500,
                ),
          ),
        ),
      ),
    );
  }
}
