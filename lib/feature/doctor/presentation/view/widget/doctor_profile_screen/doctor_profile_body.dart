import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/view/widget/doctor_profile_screen/edit_item.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/view/widget/doctor_profile_screen/personal_image.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/view/widget/doctor_profile_screen/profile_title.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/view/widget/doctor_profile_screen/setting_item.dart';

class DoctorProfileBody extends StatelessWidget {
  const DoctorProfileBody({super.key, required this.doctor});
  final DoctorEntity doctor;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppPadding.horizontal),
      child: Column(
        children: [
          PersonalImage(
            imageUrl: doctor.image,
          ),
          16.hBox,
          Text(doctor.name ?? "No Name",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          4.hBox,
          Text(doctor.email ?? "No Email",
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: AppColors.grey)),
          12.hBox,
          Text(
            doctor.bio ?? "",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          30.hBox,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileTitle(
                title: "Doctor Information",
                icon: Icons.medical_services,
              ),
              10.hBox,
              EditItem(
                title: "Personal Information",
                subtitle: doctor.phone ?? "",
                onTap: () {
                  context.pushNamed(Routes.doctorPersonalInfo,
                      arguments: doctor);
                },
              ),
              15.hBox,
              EditItem(
                title: "Specialty",
                subtitle: doctor.specialtyData?.nameEn ?? "Not Specified",
                onTap: () {
                  context.pushNamed(Routes.doctorSpecialtyScreen,
                      arguments: doctor.specialty);
                },
              ),
              15.hBox,
              EditItem(
                title: "Education",
                subtitle: doctor.education?.university ?? "Education is empty",
                onTap: () {
                  context.pushNamed(
                    Routes.doctorEducationScreen,
                    arguments: doctor.education,
                  );
                },
              ),
              20.hBox,
              const ProfileTitle(title: "Setting", icon: Icons.settings),
              10.hBox,
              const SettingItem(title: "About Us", icon: Icons.info_outline),
              15.hBox,
              const SettingItem(title: "Privacy", icon: Icons.privacy_tip),
              15.hBox,
              const SettingItem(title: "LogOut", icon: Icons.logout),
            ],
          ),
        ],
      ),
    );
  }
}
