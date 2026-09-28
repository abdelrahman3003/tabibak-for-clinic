import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_padding.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_widget.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/core/widgets/text_form_filed_widget.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_structure_screen/%20clinic_is_online.dart';

class ClinicStructureScreen extends StatefulWidget {
  const ClinicStructureScreen({super.key});

  @override
  State<ClinicStructureScreen> createState() => _ClinicStructureScreenState();
}

class _ClinicStructureScreenState extends State<ClinicStructureScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController clinicNameController;
  late TextEditingController clinicPhoneController;
  late TextEditingController clinicConsultationFeeController;
  late TextEditingController clinicFollowUpFeeController;
  
  bool isOnline = false;

  @override
  void initState() {
    clinicNameController = TextEditingController();
    clinicPhoneController = TextEditingController();
    clinicConsultationFeeController = TextEditingController();
    clinicFollowUpFeeController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: AppString.createClinic),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppPadding.horizontal,
            0,
            AppPadding.horizontal,
            MediaQuery.of(context).viewInsets.bottom + 30,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormFiledWidget(
                  label: AppString.clinicName,
                  controller: clinicNameController,
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? AppString.clinicNameValidator
                          : null,
                ),
                TextFormFiledWidget(
                  label: AppString.phoneNumber,
                  keyboardType: TextInputType.number,
                  controller: clinicPhoneController,
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? AppString.phoneValidator
                          : null,
                ),
                TextFormFiledWidget(
                  label: AppString.consultationFee,
                  keyboardType: TextInputType.number,
                  controller: clinicConsultationFeeController,
                  suffixText: AppString.egyptianPound,
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? AppString.consultationFeeValidator
                          : null,
                ),
                TextFormFiledWidget(
                  label: AppString.followUpFee,
                  keyboardType: TextInputType.number,
                  controller: clinicFollowUpFeeController,
                  suffixText: AppString.egyptianPound,
                ),
                20.hBox,
                ClinicIsOnline(
                  onChanged: (value) {
                    setState(() {
                      isOnline = value!;
                    });
                  },
                ),
                30.hBox,
                AppButton(
                  title: AppString.continueButton,
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    final partialInfo = ClinicInfoEntity(
                      clinicName: clinicNameController.text.trim(),
                      phoneNumber: clinicPhoneController.text.trim(),
                      consultationFee: int.tryParse(clinicConsultationFeeController.text) ?? 0,
                      followUpFee: int.tryParse(clinicFollowUpFeeController.text) ?? 0,
                      isBooking: isOnline,
                    );

                    context.pushNamed(
                      Routes.clinicCreationAddressScreen,
                      arguments: partialInfo,
                    );
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    clinicNameController.dispose();
    clinicPhoneController.dispose();
    clinicConsultationFeeController.dispose();
    clinicFollowUpFeeController.dispose();
    super.dispose();
  }
}


