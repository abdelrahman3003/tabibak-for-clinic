import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/constant/app_padding.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/managers/license_bloc/license_bloc.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/confirm_button.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/upload_image_widget.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart';

class ProfessionalLicenseScreen extends StatelessWidget {
  const ProfessionalLicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doctor = ModalRoute.of(context)!.settings.arguments as DoctorEntity;

    String? medicalLicense;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppString.professionalPracticeLicense,
            style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppPadding.horizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30.h),
            Text(
              AppString.uploadLicense,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            Text(
              AppString.uploadLicenseDescription,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
            ),
            40.hBox,
            UploadImageWidget(
              onChangedImageName: (imageName) {
                medicalLicense = imageName;
              },
            ),
            const Spacer(),
            ConfirmButton(
              email: doctor.email ?? "",
              onPressed: () {
                context.read<LicenseBloc>().add(AddDoctorEvent(
                        doctorEntity: DoctorEntity(
                      name: doctor.name,
                      email: doctor.email,
                      phone: doctor.phone,
                      specialty: doctor.specialty,
                      medicalLicense: medicalLicense,
                    )));
              },
            )
          ],
        ),
      ),
    );
  }
}
