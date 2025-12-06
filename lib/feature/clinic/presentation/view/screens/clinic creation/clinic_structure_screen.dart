import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_widget.dart';
import 'package:tabibak_for_clinic/core/widgets/text_form_filed_widget.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_structure_screen/%20clinic_is_online.dart';

class ClinicStructureScreen extends StatefulWidget {
  const ClinicStructureScreen({super.key});

  @override
  State<ClinicStructureScreen> createState() => _ClinicStructureScreenState();
}

class _ClinicStructureScreenState extends State<ClinicStructureScreen> {
  late TextEditingController clinicNameController;
  late TextEditingController clinicPhoneController;
  late TextEditingController clinicConsultationFeeController;
  late TextEditingController clinicIsBookingController;
  bool isOnline = false;
  @override
  void initState() {
    clinicNameController = TextEditingController();
    clinicPhoneController = TextEditingController();
    clinicConsultationFeeController = TextEditingController();
    clinicIsBookingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarWidget(title: "Create Clinic"),
        body: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
          child: Column(
            children: [
              TextFormFiledWidget(
                label: "Clinic Name",
                controller: TextEditingController(),
              ),
              const TextFormFiledWidget(
                  label: "Phone Number", keyboardType: TextInputType.number),
              const TextFormFiledWidget(
                label: "Consultation Fee",
                keyboardType: TextInputType.number,
                suffixText: "EGY",
              ),
              20.hBox,
              ClinicIsOnline(
                onChanged: (value) => isOnline,
              ),
              const Spacer(),
              // ClinicInfoButtonStates(
              //   clinicInfoEntity: ClinicInfoEntity(
              //     clinicName: clinicNameController.text,
              //     address: address,
              //     phoneNumber: clinicPhoneController.text,
              //     consultationFee: clinicConsultationFeeController.text,
              //     isBooking: clinicIsBookingController.text,
              //     doctorId: doctorId,
              //   ),
              // ),
              25.hBox,
            ],
          ),
        ));
  }

  @override
  void dispose() {
    clinicNameController.dispose();
    clinicPhoneController.dispose();
    clinicConsultationFeeController.dispose();
    clinicNameController.dispose();
    super.dispose();
  }
}
