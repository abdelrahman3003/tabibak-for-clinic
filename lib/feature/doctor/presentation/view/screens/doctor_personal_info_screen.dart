import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_save.dart';
import 'package:tabibak_for_clinic/core/widgets/dialogs.dart';
import 'package:tabibak_for_clinic/core/widgets/text_form_filed_widget.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/manager/doctor_info/doctor_info_bloc.dart';

class DoctorPersonalInfo extends StatefulWidget {
  const DoctorPersonalInfo({super.key});

  @override
  State<DoctorPersonalInfo> createState() => _DoctorPersonalInfoState();
}

class _DoctorPersonalInfoState extends State<DoctorPersonalInfo> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final bioController = TextEditingController();
  @override
  void didChangeDependencies() {
    final doctor = ModalRoute.of(context)!.settings.arguments as DoctorEntity;
    nameController.text = doctor.name ?? "";
    phoneController.text = doctor.phone ?? "";
    bioController.text = doctor.bio ?? "";
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarSave(
        text: "Doctor Personal Info",
        onTap: () {
          context.read<DoctorInfoBloc>().add(
                UpdateDoctorInfo(
                  name: nameController.text,
                  phone: phoneController.text,
                  bio: bioController.text,
                ),
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
              context.pushNamed(Routes.layOutScreen);
            }
            if (state is DoctorInfoFailed) {
              Dialogs.errorDialog(context, state.errorMessage);
            }
          },
          child: Column(
            children: [
              TextFormFiledWidget(
                label: "Doctor Name",
                controller: nameController,
              ),
              TextFormFiledWidget(
                label: "Phone",
                controller: phoneController,
              ),
              TextFormFiledWidget(
                label: "Bio",
                controller: bioController,
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
    bioController.dispose();
    super.dispose();
  }
}
