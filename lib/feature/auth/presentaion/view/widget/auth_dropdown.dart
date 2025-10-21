import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constatnt/app_string.dart';

class AuthDropdown extends StatefulWidget {
  const AuthDropdown({super.key});

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
    return SizedBox(
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
          });
        },
      ),
    );
  }
}
