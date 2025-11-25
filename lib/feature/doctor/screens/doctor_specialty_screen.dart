import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/specialty_entity.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/auth_dropdown.dart';
import 'package:tabibak_for_clinic/feature/doctor/widget/doctor_personal_info_screen/app_bar_save.dart';

class DoctorSpecialtyScreen extends StatelessWidget {
  const DoctorSpecialtyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: AppBarSave(text: "Doctor Specialty"),
        body: SpecialtyDropdown(
          color: Colors.transparent,
          items: [
            SpecialtyEntity(
                id: 1, nameAr: "nameAr", nameEn: "nameEn", icon: "icon"),
            SpecialtyEntity(
                id: 2, nameAr: "nameAr", nameEn: "nameEn", icon: "icon")
          ],
        ));
  }
}
