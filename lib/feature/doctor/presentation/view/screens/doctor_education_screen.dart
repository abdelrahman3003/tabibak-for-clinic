import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/functions/pick_image.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_save.dart';
import 'package:tabibak_for_clinic/core/widgets/app_snack_bar.dart';
import 'package:tabibak_for_clinic/core/widgets/dialogs.dart';
import 'package:tabibak_for_clinic/core/widgets/text_form_filed_widget.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/education_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/manager/doctor_education/doctor_education_bloc.dart';

class DoctorEducationScreen extends StatefulWidget {
  const DoctorEducationScreen({super.key});

  @override
  State<DoctorEducationScreen> createState() => _DoctorEducationScreenState();
}

class _DoctorEducationScreenState extends State<DoctorEducationScreen> {
  final countryController = TextEditingController();
  final universityController = TextEditingController();
  final degreeController = TextEditingController();
  final yearController = TextEditingController();
  List<XFile?> files = [];

  @override
  void didChangeDependencies() {
    final education =
        ModalRoute.of(context)?.settings.arguments as EducationEntity?;
    if (education != null) {
      countryController.text = education.country ?? "";
      universityController.text = education.university ?? "";
      degreeController.text = education.degree ?? "";
      yearController.text = education.year?.toString() ?? "";
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarSave(
          text: "Doctor Education",
          onTap: () {
            context.read<DoctorEducationBloc>().add(
                  UpdateDoctorEducationEvent(
                      files: files,
                      educationEntity: EducationEntity(
                        university: universityController.text,
                        country: countryController.text,
                        degree: degreeController.text,
                        year: int.tryParse(yearController.text),
                      )),
                );
          },
        ),
        body: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
          child: BlocListener<DoctorEducationBloc, DoctorEducationState>(
            listener: (context, state) {
              if (state is DoctorEducationLoading) {
                Dialogs.showLoading(context);
              }
              if (state is DoctorEducationSuccess) {
                context.pop();
                context.pushNamed(Routes.layOutScreen);
              }
              if (state is DoctorEducationFailed) {
                context.pop();
                AppSnackBar.show(context: context, message: state.errorMessage);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.hBox,
                TextFormFiledWidget(
                  label: "Country",
                  controller: countryController,
                ),
                TextFormFiledWidget(
                  label: "University",
                  controller: universityController,
                ),
                TextFormFiledWidget(
                  label: "Degree",
                  controller: degreeController,
                ),
                TextFormFiledWidget(
                  label: "Year",
                  controller: yearController,
                  keyboardType: TextInputType.number,
                ),
                Text(
                  "Certificate Photo",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                10.hBox,
                _buildCertificatePhoto(context)
              ],
            ),
          ),
        ));
  }

  _buildCertificatePhoto(BuildContext context) {
    return InkWell(
      onTap: () async {
        final file = await pickImage();
        files.add(file);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(border: Border.all(color: AppColors.primary)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
            5.wBox,
            Text(
              "Certificate Photo",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    countryController.dispose();
    universityController.dispose();
    degreeController.dispose();
    yearController.dispose();

    super.dispose();
  }
}
