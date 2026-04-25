import 'package:flutter/material.dart';

class AppDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final String hint;
  final Widget? prefixIcon;
  final String Function(T item) labelBuilder;
  final void Function(T? value)? onChanged;
  final String? Function(T?)? validator;
  final EdgeInsetsGeometry? contentPadding;
  final Color? filledColor;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  const AppDropdown({
    super.key,
    required this.items,
    required this.labelBuilder,
    required this.hint,
    this.value,
    this.prefixIcon,
    this.onChanged,
    this.validator,
    this.contentPadding,
    this.filledColor,
    this.textStyle,
    this.hintStyle,
  });

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  T? selectedItem;

  @override
  void initState() {
    selectedItem = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: selectedItem,
      hint: Text(widget.hint, style: widget.hintStyle

          // hint color here
          ),
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        border: const UnderlineInputBorder(),
        filled: true,
        fillColor: widget.filledColor ??
            Theme.of(context).inputDecorationTheme.fillColor,
        contentPadding:
            widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 10),
      ),
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      items: widget.items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(widget.labelBuilder(item)),
            ),
          )
          .toList(),
      style: widget.textStyle,
      onChanged: (value) {
        setState(() => selectedItem = value);
        widget.onChanged?.call(value);
      },
    );
  }
}
