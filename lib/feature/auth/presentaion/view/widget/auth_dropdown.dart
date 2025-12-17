import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/specialty_entity.dart';

class SpecialtyDropdown extends StatefulWidget {
  final Function(int?)? onChanged;
  final List<SpecialtyEntity> items;
  final Color? color;
  const SpecialtyDropdown(
      {super.key, this.onChanged, required this.items, this.color});

  @override
  State<SpecialtyDropdown> createState() => _SpecialtyDropdownState();
}

int? _selectedSpecialtyId;

class _SpecialtyDropdownState extends State<SpecialtyDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        hintText: "Select Specialty",
        fillColor: widget.color,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      validator: (value) => value == null ? "Please select a specialty" : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: _selectedSpecialtyId,
      items: widget.items
          .map(
            (item) => DropdownMenuItem(
              value: item.id,
              child: Text(item.nameEn),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() => _selectedSpecialtyId = value);
        if (widget.onChanged != null) widget.onChanged!(value);
      },
    );
  }
}
