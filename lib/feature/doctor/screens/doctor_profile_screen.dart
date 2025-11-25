import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/feature/doctor/widget/edit_item.dart';
import 'package:tabibak_for_clinic/feature/doctor/widget/personal_image.dart';
import 'package:tabibak_for_clinic/feature/doctor/widget/profile_title.dart';

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
          padding: const EdgeInsets.all(16),
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
                style: Theme.of(context).textTheme.titleMedium,
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
                  20.hBox,
                  EditItem(
                    title: "Personal Information",
                    subtitle: doctorPhone,
                    onTap: () {},
                  ),
                  15.hBox,
                  EditItem(
                    title: "Specialty",
                    subtitle: doctorSpecialty,
                  ),
                  15.hBox,
                  EditItem(
                    title: "Education",
                    subtitle: doctorEducation,
                  ),
                  30.hBox,
                  const ProfileTitle(
                    title: "Clinic Information",
                    icon: Icons.medical_services,
                  ),
                  20.hBox,
                  const EditItem(
                    title: "Clinic Info",
                    subtitle: "Healthy Heart Clinic",
                  ),
                  15.hBox,
                  const EditItem(
                    title: "Clinic Address",
                    subtitle: "نجع حمادي",
                  ),
                  15.hBox,
                  const EditItem(
                    title: "Clinic Offer",
                    subtitle: "Sat-Thu: 9:00 AM - 5:00 PM",
                  ),
                  10.hBox,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
