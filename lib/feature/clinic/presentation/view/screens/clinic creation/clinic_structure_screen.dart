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
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/governorate_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_info/clinic_info_bloc.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_structure_screen/%20clinic_is_online.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_structure_screen/governorate_init_drop_down.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_structure_screen/markaz_init_drop_down.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_structure_screen/village_init_drop_down.dart';
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
  late TextEditingController clinicFollowUpFeeController;
  
  GovernorateEntity? selectedGovernorate;
  CityEntity? selectedMarkaz;
  CityEntity? selectedVillage;
  bool isOnline = false;

  @override
  void initState() {
    clinicNameController = TextEditingController();
    clinicPhoneController = TextEditingController();
    clinicConsultationFeeController = TextEditingController();
    clinicFollowUpFeeController = TextEditingController();
    context.read<ClinicInfoBloc>().add(const GetGovernoratesEvent());
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
          child: Column(
            children: [
              TextFormFiledWidget(
                label: AppString.clinicName,
                controller: clinicNameController,
              ),
              GovernorateInitDropDown(
                initialValue: selectedGovernorate,
                onChanged: (value) {
                  setState(() {
                    selectedGovernorate = value;
                    selectedMarkaz = null;
                    selectedVillage = null;
                  });
                  if (value?.id != null) {
                    context.read<ClinicInfoBloc>().add(
                        GetCitiesByGovernorateEvent(
                            governorateId: value!.id!));
                  }
                },
              ),
              MarkazInitDropDown(
                initialValue: selectedMarkaz,
                onChanged: (value) {
                  setState(() {
                    selectedMarkaz = value;
                    selectedVillage = null;
                  });
                  if (value?.id != null) {
                    context.read<ClinicInfoBloc>().add(
                        GetCitiesByParentEvent(parentId: value!.id!));
                  }
                },
              ),
              VillageInitDropDown(
                initialValue: selectedVillage,
                onChanged: (value) {
                  setState(() {
                    selectedVillage = value;
                  });
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
              ClinicInfoButtonStates(
                onPressed: () {
                  context.read<ClinicInfoBloc>().add(
                        CreateClinicInfoEvent(
                          clinicInfoEntity: ClinicInfoEntity(
                            clinicName: clinicNameController.text,
                            phoneNumber: clinicPhoneController.text,
                            consultationFee: int.tryParse(
                                    clinicConsultationFeeController.text) ??
                                0,
                            followUpFee: int.tryParse(
                                    clinicFollowUpFeeController.text) ??
                                0,
                            isBooking: isOnline,
                            address: ClinicAddressEntity(
                              governorate: selectedGovernorate,
                              markaz: selectedMarkaz,
                              village: selectedVillage,
                            ),
                          ),
                        ),
                      );
                },
              ),
              const SizedBox(height: 30),
            ],
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

