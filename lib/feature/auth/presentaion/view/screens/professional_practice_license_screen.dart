import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/constatnt/app_values.dart';
import 'package:tabibak_for_clinic/core/extenstion/spacing.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/doctor_entity.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/managers/sign_up_bloc/signup_bloc.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/confirm_button.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/upload_image_widget.dart';

class ProfessionalPracticeLicenseScreen extends StatelessWidget {
  const ProfessionalPracticeLicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final name = args["name"];
    final email = args["email"];
    final phone = args["phone"];
    final password = args["password"];
    final specialization = args["specialization"];
    final user = args['user'] as User?;
    String? medicalLiecense;
    return Scaffold(
      appBar: AppBar(
        title: Text("Professional Practice License",
            style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppPadding.horizontal),
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
                medicalLiecense = imageName;
              },
            ),
            const Spacer(),
            ConfirmButton(
              onPressed: () {
                context.read<SignupBloc>().add(SignupRequested(
                    doctorEntity: DoctorEntity(
                      name: name,
                      phone: phone,
                      email: email,
                      specialty: specialization,
                      medicalLiecense: medicalLiecense!,
                    ),
                    password: password,
                    user: user));
              },
            )
          ],
        ),
      ),
    );
  }
}
