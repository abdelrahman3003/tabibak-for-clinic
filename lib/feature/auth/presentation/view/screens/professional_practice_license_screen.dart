import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
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
        title: Text("Professional Practice License",
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
              "Upload your professional practice license",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            Text(
              "Please provide a clear image of your valid license to verify your professional status.",
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
              onPressed: () {
                context.pushNamed(Routes.checkEmailScreen,
                    arguments: doctor.email);
                // context.read<SignupBloc>().add(SignupRequestedEvent(
                //     doctorEntity:
                //         doctor.copyWith(medicalLicense: medicalLicense)));
              },
            )
          ],
        ),
      ),
    );
  }
}
