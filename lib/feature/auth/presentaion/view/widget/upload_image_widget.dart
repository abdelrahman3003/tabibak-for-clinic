import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/managers/sign_up_bloc/signup_bloc.dart';

class UploadImageWidget extends StatelessWidget {
  const UploadImageWidget({super.key, this.onChangedImageName});
  final Function(String?)? onChangedImageName;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupBloc, SignupState>(
      buildWhen: (previous, current) => current is UploadFileSuccess,
      listener: (context, state) {
        if (state is UploadFileSuccess) {
          onChangedImageName?.call(state.file?.path);
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () async {
            context.read<SignupBloc>().add(UploadFileEvent());
          },
          child: Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.primary, width: 2),
                color: AppColors.primaryLight),
            child: state is UploadFileSuccess
                ? _buildPreview(state.file?.path)
                : _buildUploadPlaceholder(),
          ),
        );
      },
    );
  }

  ClipRRect _buildPreview(String? filePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: Image.file(
        File(filePath!),
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }

  Column _buildUploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.cloud_upload_outlined,
            size: 60.sp, color: AppColors.primary),
        SizedBox(height: 10.h),
        Text(
          "Tap to upload license",
          style: TextStyle(fontSize: 16.sp, color: AppColors.primary),
        ),
      ],
    );
  }
}
