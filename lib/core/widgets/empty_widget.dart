import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "No Data Found",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
