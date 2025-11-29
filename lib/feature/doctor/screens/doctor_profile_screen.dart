import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/feature/doctor/widget/doctor_profile_screen/edit_item.dart';
import 'package:tabibak_for_clinic/feature/doctor/widget/doctor_profile_screen/personal_image.dart';
import 'package:tabibak_for_clinic/feature/doctor/widget/doctor_profile_screen/profile_title.dart';
import 'package:tabibak_for_clinic/feature/doctor/widget/doctor_profile_screen/setting_item.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  final String doctorName = "Dr. Ahmed Ali";
  final String doctorEmail = "dr.ahmed@example.com";
  final String doctorPhone = "+20 123456789";
  final String doctorBio =
      "Experienced cardiologist with over 15 years of practice, specialized in heart diseases and patient care.";
  final String doctorSpecialty = "Cardiology";
  final String doctorEducation = "MBBS, MD Cardiology";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppPadding.horizontal),
          child: Column(
            children: [
              const PersonalImage(),
              16.hBox,
              Text(doctorName,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              4.hBox,
              Text(doctorEmail,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppColors.grey)),
              12.hBox,
              Text(
                doctorBio,
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
                    subtitle: doctorPhone,
                    onTap: () {
                      context.pushNamed(Routes.doctorPersonalInfo);
                    },
                  ),
                  15.hBox,
                  EditItem(
                    title: "Specialty",
                    subtitle: doctorSpecialty,
                    onTap: () {
                      context.pushNamed(Routes.doctorSpecialtyScreen);
                    },
                  ),
                  15.hBox,
                  EditItem(
                    title: "Education",
                    subtitle: doctorEducation,
                    onTap: () {
                      context.pushNamed(Routes.doctorEducationScreen);
                    },
                  ),
                  20.hBox,
                  const ProfileTitle(title: "Setting", icon: Icons.settings),
                  10.hBox,
                  const SettingItem(
                      title: "About Us", icon: Icons.info_outline),
                  15.hBox,
                  const SettingItem(title: "Privacy", icon: Icons.privacy_tip),
                  15.hBox,
                  const SettingItem(title: "LogOut", icon: Icons.logout),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
