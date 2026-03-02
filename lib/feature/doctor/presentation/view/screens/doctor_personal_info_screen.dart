import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/constant/app_padding.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_save.dart';
import 'package:tabibak_for_clinic/core/widgets/app_snack_bar.dart';
import 'package:tabibak_for_clinic/core/widgets/dialogs.dart';
import 'package:tabibak_for_clinic/core/widgets/text_form_filed_widget.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/manager/doctor_info/doctor_info_bloc.dart';
import 'package:tabibak_for_clinic/layout_screen.dart';

class DoctorPersonalInfo extends StatefulWidget {
  const DoctorPersonalInfo({super.key, required this.doctorEntity});

  final DoctorEntity doctorEntity;

  @override
  State<DoctorPersonalInfo> createState() => _DoctorPersonalInfoState();
}

class _DoctorPersonalInfoState extends State<DoctorPersonalInfo> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final bioArController = TextEditingController();
  final bioEnController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.doctorEntity.name ?? "";
    phoneController.text = widget.doctorEntity.phone ?? "";

    bioArController.text = widget.doctorEntity.bioAr ?? "";
    bioEnController.text = widget.doctorEntity.bioEn ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarSave(
        text: AppString.doctorPersonalInfo,
        onTap: () {
          context.read<DoctorInfoBloc>().add(
                UpdateDoctorInfo(
                    name: nameController.text,
                    phone: phoneController.text,
                    bioAr: bioArController.text,
                    bioEn: bioEnController.text),
              );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
        child: BlocListener<DoctorInfoBloc, DoctorInfoState>(
          listener: (context, state) {
            if (state is DoctorInfoLoading) {
              Dialogs.showLoading(context);
            }
            if (state is DoctorInfoSuccess) {
              context.pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LayoutScreen(initialIndex: 2),
                  ));
              AppSnackBar.show(
                  context: context, message: "Doctor info was Updated");
            }
            if (state is DoctorInfoFailed) {
              context.pop();
              AppSnackBar.show(context: context, message: state.errorMessage);
            }
          },
          child: Column(
            children: [
              TextFormFiledWidget(
                label: AppString.doctorName,
                controller: nameController,
              ),
              TextFormFiledWidget(
                label: AppString.phoneNumber,
                controller: phoneController,
              ),
              TextFormFiledWidget(
                contentPadding: EdgeInsets.symmetric(vertical: 16.h),
                label: AppString.bio,
                controller: bioArController,
              ),
              TextFormFiledWidget(
                contentPadding: EdgeInsets.symmetric(vertical: 16.h),
                label: AppString.bio,
                controller: bioEnController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    bioArController.dispose();
    bioEnController.dispose();
    super.dispose();
  }
}
