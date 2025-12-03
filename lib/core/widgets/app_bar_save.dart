import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_widget.dart';

class AppBarSave extends AppBarWidget {
  const AppBarSave({super.key, this.onTap, required this.text});
  final Function()? onTap;
  final String text;
  @override
  Widget build(BuildContext context) {
    return AppBarWidget(
      title: text,
      actions: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Text(
              "Save",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }
}
