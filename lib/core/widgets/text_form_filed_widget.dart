import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFormFiledWidget extends StatelessWidget {
  const TextFormFiledWidget(
      {super.key,
      this.controller,
      required this.label,
      this.keyboardType,
      this.suffixText,
      this.maxLines});
  final TextEditingController? controller;
  final String label;
  final TextInputType? keyboardType;
  final String? suffixText;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: TextFormField(
        maxLines: maxLines,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          suffixIcon: _buildSuffixText(context),
          labelText: label,
          labelStyle: Theme.of(context).textTheme.titleMedium,
          contentPadding: EdgeInsets.zero,
          border: const UnderlineInputBorder(),
          fillColor: Colors.transparent,
          filled: true,
        ),
      ),
    );
  }

  Widget? _buildSuffixText(BuildContext context) {
    return suffixText == null
        ? null
        : Padding(
            padding: EdgeInsets.only(top: 15.h),
            child: Text(
              suffixText!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.secondary),
            ),
          );
  }
}
