import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key, this.message});
  final String? message;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.event_available_outlined,
          size: 50,
          color: Colors.grey.shade400,
        ),
        16.hBox,
        Text(
          message ?? "",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
