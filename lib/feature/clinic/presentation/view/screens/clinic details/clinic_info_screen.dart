import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_save.dart';
import 'package:tabibak_for_clinic/core/widgets/text_form_filed_widget.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';

class ClinicInfoScreen extends StatefulWidget {
  const ClinicInfoScreen({super.key});

  @override
  State<ClinicInfoScreen> createState() => _ClinicInfoScreenState();
}

class _ClinicInfoScreenState extends State<ClinicInfoScreen> {
  late TextEditingController _clinicNameController;
  late TextEditingController _phoneController;
  late TextEditingController _feeController;
  @override
  void initState() {
    _clinicNameController = TextEditingController();
    _phoneController = TextEditingController();
    _feeController = TextEditingController();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    final clinicInfo =
        ModalRoute.of(context)!.settings.arguments as ClinicInfoEntity;
    _clinicNameController.text = clinicInfo.clinicName ?? '';
    _phoneController.text = clinicInfo.phoneNumber ?? '';
    _feeController.text = clinicInfo.consultationFee?.toString() ?? '';
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarSave(
          text: "Clinic Info",
          onTap: () {},
        ),
        body: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
          child: Column(
            children: [
              TextFormFiledWidget(
                label: "Clinic Name",
                controller: _clinicNameController,
              ),
              TextFormFiledWidget(
                label: "Phone Number",
                keyboardType: TextInputType.number,
                controller: _phoneController,
              ),
              TextFormFiledWidget(
                label: "Consultation Fee",
                keyboardType: TextInputType.number,
                controller: _feeController,
                suffixText: "EGY",
              ),
            ],
          ),
        ));
  }
}
