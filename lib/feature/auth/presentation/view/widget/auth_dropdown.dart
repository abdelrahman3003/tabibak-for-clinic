import 'package:flutter/material.dart';

class AppDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final String hint;
  final Color? color;
  final String Function(T item) labelBuilder;
  final void Function(T? value)? onChanged;
  final String? Function(T?)? validator;

  const AppDropdown({
    super.key,
    required this.items,
    required this.labelBuilder,
    required this.hint,
    this.value,
    this.color,
    this.onChanged,
    this.validator,
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
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: Theme.of(context).textTheme.titleMedium,
        fillColor: Colors.transparent,
        filled: true,
        contentPadding: EdgeInsets.zero, // <--- هنا شيل البادينج
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
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
      onChanged: (value) {
        setState(() => selectedItem = value);
        widget.onChanged?.call(value);
      },
    );
  }
}
