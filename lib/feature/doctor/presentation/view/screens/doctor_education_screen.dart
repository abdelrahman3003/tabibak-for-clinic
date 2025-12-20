import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_save.dart';
import 'package:tabibak_for_clinic/core/widgets/app_snack_bar.dart';
import 'package:tabibak_for_clinic/core/widgets/dialogs.dart';
import 'package:tabibak_for_clinic/core/widgets/text_form_filed_widget.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/education_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/manager/doctor_education/doctor_education_bloc.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/view/widget/doctor_profile_screen/education_certificates.dart';

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
  XFile? file;
  EducationEntity? education;
  @override
  void didChangeDependencies() {
    education = ModalRoute.of(context)?.settings.arguments as EducationEntity?;

    if (education != null) {
      countryController.text = education?.country ?? "";
      universityController.text = education?.university ?? "";
      degreeController.text = education?.degree ?? "";
      yearController.text = education?.year?.toString() ?? "";
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
                      file: file,
                      educationEntity: EducationEntity(
                        university: universityController.text,
                        country: countryController.text,
                        degree: degreeController.text,
                        year: int.tryParse(
                          yearController.text,
                        ),
                        certificate: education?.certificate,
                      )),
                );
          },
        ),
        body: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
          child: BlocListener<DoctorEducationBloc, DoctorEducationState>(
            listenWhen: (previous, current) =>
                current is DoctorEducationLoading ||
                current is DoctorEducationSuccess ||
                current is DoctorEducationFailed,
            listener: (context, state) {
              if (state is DoctorEducationLoading) {
                Dialogs.showLoading(context);
              }
              if (state is DoctorEducationSuccess) {
                context.pop();
                context.pushNamed(Routes.layOutScreen, arguments: 2);
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
                EducationCertificates(
                  imageUrl: education?.certificate,
                  onSelected: (selectedFile) {
                    file = selectedFile;
                  },
                )
              ],
            ),
          ),
        ));
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
