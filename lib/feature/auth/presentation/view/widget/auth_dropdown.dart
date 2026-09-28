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
  void didUpdateWidget(AppDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      selectedItem = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure selectedItem is present in items to prevent Flutter assertion errors
    if (selectedItem != null && widget.items.isNotEmpty) {
      if (!widget.items.contains(selectedItem)) {
        // If not found by equality, try to clear it or it will crash.
        // We will just set it to null if it's strictly not in the items list.
        selectedItem = null;
      }
    }

    return DropdownButtonFormField<T>(
      value: selectedItem,
      hint: Text(widget.hint, style: widget.hintStyle),
      decoration: InputDecoration(
        hintText: selectedItem == null ? widget.hint : null,
        labelText: selectedItem != null ? widget.hint : null,
        labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
        prefixIcon: widget.prefixIcon,
        contentPadding:
            widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 10),
        fillColor: Colors.transparent,
        filled: true,
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
