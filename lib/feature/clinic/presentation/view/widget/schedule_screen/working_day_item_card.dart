import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';

class WorkingDayItemCard extends StatefulWidget {
  const WorkingDayItemCard(
      {super.key,
      required this.day,
      this.isActive = false,
      required this.onChanged});
  final String day;
  final bool isActive;
  final ValueChanged<bool> onChanged;
  @override
  State<WorkingDayItemCard> createState() => _WorkingDayItemCardState();
}

class _WorkingDayItemCardState extends State<WorkingDayItemCard> {
  bool isInternalActive = false;

  @override
  void initState() {
    isInternalActive = widget.isActive;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isInternalActive = !isInternalActive;
        setState(() {});
        widget.onChanged(isInternalActive);
      },
      child: AnimatedContainer(
        duration: const Duration(microseconds: 400),
        decoration: BoxDecoration(
            color: isInternalActive
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xffD1D5DB))),
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Text(
            widget.day,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isInternalActive ? AppColors.white : AppColors.black),
          ),
        ),
      ),
    );
  }
}
