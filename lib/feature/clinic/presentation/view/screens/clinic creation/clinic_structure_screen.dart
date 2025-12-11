import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_widget.dart';
import 'package:tabibak_for_clinic/core/widgets/text_form_filed_widget.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_info/clinic_info_bloc.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_structure_screen/%20clinic_is_online.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_structure_screen/clinic_info_button_states.dart';

class ClinicStructureScreen extends StatefulWidget {
  const ClinicStructureScreen({super.key});

  @override
  State<ClinicStructureScreen> createState() => _ClinicStructureScreenState();
}

class _ClinicStructureScreenState extends State<ClinicStructureScreen> {
  late TextEditingController clinicNameController;
  late TextEditingController clinicPhoneController;
  late TextEditingController clinicAddressController;
  late TextEditingController clinicConsultationFeeController;

  bool isOnline = false;

  @override
  void initState() {
    clinicNameController = TextEditingController();
    clinicPhoneController = TextEditingController();
    clinicConsultationFeeController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: "Create Clinic"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
        child: Column(
          children: [
            TextFormFiledWidget(
              label: "Clinic Name",
              controller: clinicNameController,
            ),
            TextFormFiledWidget(
              label: "Phone Number",
              keyboardType: TextInputType.number,
              controller: clinicPhoneController,
            ),
            TextFormFiledWidget(
              label: "Address",
              controller: clinicAddressController,
            ),
            TextFormFiledWidget(
              label: "Consultation Fee",
              keyboardType: TextInputType.number,
              controller: clinicConsultationFeeController,
              suffixText: "EGY",
            ),
            20.hBox,
            ClinicIsOnline(
              onChanged: (value) {
                setState(() {
                  isOnline = value!;
                });
              },
            ),
            const Spacer(),
            ClinicInfoButtonStates(
              onPressed: () {
                context.read<ClinicInfoBloc>().add(CreateClinicInfoEvent(
                      clinicInfoEntity: ClinicInfoEntity(
                        clinicName: clinicNameController.text,
                        phoneNumber: clinicPhoneController.text,
                        address: clinicAddressController.text,
                        consultationFee: int.tryParse(
                                clinicConsultationFeeController.text) ??
                            0,
                        isBooking: isOnline,
                      ),
                    ));
              },
            ),
            25.hBox,
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    clinicNameController.dispose();
    clinicPhoneController.dispose();
    clinicAddressController.dispose();
    clinicConsultationFeeController.dispose();
    super.dispose();
  }
}
