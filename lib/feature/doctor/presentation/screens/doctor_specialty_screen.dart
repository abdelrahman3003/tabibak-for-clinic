import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_save.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/auth_dropdown.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/specialty_entity.dart';

class DoctorSpecialtyScreen extends StatelessWidget {
  const DoctorSpecialtyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: AppBarSave(text: "Doctor Specialty"),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
          child: SpecialtyDropdown(
            color: Colors.transparent,
            items: [
              SpecialtyEntity(
                  id: 1, nameAr: "nameAr", nameEn: "nameEn", icon: "icon"),
              SpecialtyEntity(
                  id: 2, nameAr: "nameAr", nameEn: "nameEn", icon: "icon")
            ],
          ),
        ));
  }
}
