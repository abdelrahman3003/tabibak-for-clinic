import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_padding.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_widget.dart';
import 'package:tabibak_for_clinic/core/widgets/text_form_filed_widget.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/city_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_address_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_info/clinic_info_bloc.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_structure_screen/%20clinic_is_online.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_structure_screen/city_init_drop_down.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_structure_screen/clinic_info_button_states.dart';

class ClinicStructureScreen extends StatefulWidget {
  const ClinicStructureScreen({super.key});

  @override
  State<ClinicStructureScreen> createState() => _ClinicStructureScreenState();
}

class _ClinicStructureScreenState extends State<ClinicStructureScreen> {
  late TextEditingController clinicNameController;
  late TextEditingController clinicPhoneController;
  late TextEditingController clinicConsultationFeeController;
  CityEntity? selectedCity;
  bool isOnline = false;

  @override
  void initState() {
    clinicNameController = TextEditingController();
    clinicPhoneController = TextEditingController();
    clinicConsultationFeeController = TextEditingController();
    context.read<ClinicInfoBloc>().add(const GetCitiesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: AppString.createClinic),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.horizontal,
                ),
                child: Column(
                  children: [
                    TextFormFiledWidget(
                      label: AppString.clinicName,
                      controller: clinicNameController,
                    ),
                    CityInitDropDown(
                      initialValue: selectedCity,
                      onChangedAddress: (value) {
                        selectedCity = value;
                      },
                    ),
                    TextFormFiledWidget(
                      label: AppString.phoneNumber,
                      keyboardType: TextInputType.number,
                      controller: clinicPhoneController,
                    ),
                    TextFormFiledWidget(
                      label: AppString.consultationFee,
                      keyboardType: TextInputType.number,
                      controller: clinicConsultationFeeController,
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
                    20.hBox, // spacing instead of Spacer()
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.horizontal,
              ).copyWith(bottom: 25),
              child: ClinicInfoButtonStates(
                onPressed: () {
                  context.read<ClinicInfoBloc>().add(CreateClinicInfoEvent(
                        clinicInfoEntity: ClinicInfoEntity(
                          clinicName: clinicNameController.text,
                          phoneNumber: clinicPhoneController.text,
                          consultationFee: int.tryParse(
                                  clinicConsultationFeeController.text) ??
                              0,
                          isBooking: isOnline,
                          address: ClinicAddressEntity(
                            city: selectedCity,
                          ),
                        ),
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    clinicNameController.dispose();
    clinicPhoneController.dispose();
    clinicConsultationFeeController.dispose();
    super.dispose();
  }
}
