import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constatnt/app_string.dart';

class AuthDropdown extends StatefulWidget {
  const AuthDropdown({super.key, this.onChanged, required this.isRegistered});
  final Function(int?)? onChanged;
  final bool isRegistered;
  @override
  State<AuthDropdown> createState() => _AuthDropdownState();
}

String? _selectedSpecialization;
List<DropdownMenuItem<String>> items = const [
  DropdownMenuItem(value: "Dentist", child: Text("Dentist")),
  DropdownMenuItem(value: "Orthopedic", child: Text("Orthopedic")),
  DropdownMenuItem(value: "Dermatologist", child: Text("Dermatologist")),
  DropdownMenuItem(value: "Cardiologist", child: Text("Cardiologist")),
];

class _AuthDropdownState extends State<AuthDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: widget.isRegistered && _selectedSpecialization == null
                ? Colors.red
                : Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          hintText: AppString.mainSpecialization,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
        value: _selectedSpecialization,
        items: items,
        onChanged: (value) {
          setState(() {
            _selectedSpecialization = value;
            if (widget.onChanged != null) {
              widget.onChanged!(_parseConsultationFee(value!));
            }
          });
        },
      ),
    );
  }
}

int _parseConsultationFee(String text) {
  switch (text) {
    case "Dentist":
      return 1;
    case "Orthopedic":
      return 2;
    case "Dermatologist":
      return 3;
    case "Cardiologist":
      return 4;
    default:
      return int.parse(text);
  }
}
