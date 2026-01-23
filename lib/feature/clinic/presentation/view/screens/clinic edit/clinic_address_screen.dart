import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_save.dart';
import 'package:tabibak_for_clinic/core/widgets/text_form_filed_widget.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_address_entity.dart';

class ClinicAddressScreen extends StatefulWidget {
  const ClinicAddressScreen({super.key});

  @override
  State<ClinicAddressScreen> createState() => _ClinicAddressScreenState();
}

late TextEditingController _clinicAddressController;

@override
class _ClinicAddressScreenState extends State<ClinicAddressScreen> {
  @override
  void initState() {
    _clinicAddressController = TextEditingController();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    final clinicInfo =
        ModalRoute.of(context)!.settings.arguments as ClinicAddressEntity?;

    _clinicAddressController.text = clinicInfo?.clinicAddress ?? '';

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarSave(text: "Clinic Address"),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              TextFormFiledWidget(
                label: "Clinic Address",
                controller: _clinicAddressController,
              ),
              const TextFormFiledWidget(label: "Clinic Directions")
            ],
          ),
        ));
  }
}
