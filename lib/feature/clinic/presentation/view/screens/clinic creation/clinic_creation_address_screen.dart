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
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_structure_screen/governorate_init_drop_down.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_structure_screen/markaz_init_drop_down.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_structure_screen/village_init_drop_down.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_structure_screen/clinic_info_button_states.dart';

class ClinicCreationAddressScreen extends StatefulWidget {
  final ClinicInfoEntity partialClinicInfo;

  const ClinicCreationAddressScreen({super.key, required this.partialClinicInfo});

  @override
  State<ClinicCreationAddressScreen> createState() => _ClinicCreationAddressScreenState();
}

class _ClinicCreationAddressScreenState extends State<ClinicCreationAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController streetController;
  late TextEditingController floorController;
  late TextEditingController departmentController;
  
  GovernorateEntity? selectedGovernorate;
  CityEntity? selectedMarkaz;
  CityEntity? selectedVillage;

  @override
  void initState() {
    streetController = TextEditingController();
    floorController = TextEditingController();
    departmentController = TextEditingController();
    context.read<ClinicInfoBloc>().add(const GetGovernoratesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: AppString.clinicAddress),
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
                15.hBox,
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
                15.hBox,
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
                15.hBox,
                VillageInitDropDown(
                  initialValue: selectedVillage,
                  onChanged: (value) {
                    setState(() {
                      selectedVillage = value;
                    });
                  },
                ),
                15.hBox,
                TextFormFiledWidget(
                  label: AppString.street,
                  controller: streetController,
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? AppString.streetValidator
                          : null,
                ),
                TextFormFiledWidget(
                  label: AppString.floor,
                  controller: floorController,
                ),
                TextFormFiledWidget(
                  label: AppString.department,
                  controller: departmentController,
                ),
                30.hBox,
                ClinicInfoButtonStates(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    context.read<ClinicInfoBloc>().add(
                          CreateClinicInfoEvent(
                            clinicInfoEntity: ClinicInfoEntity(
                              clinicName: widget.partialClinicInfo.clinicName,
                              phoneNumber: widget.partialClinicInfo.phoneNumber,
                              consultationFee: widget.partialClinicInfo.consultationFee,
                              followUpFee: widget.partialClinicInfo.followUpFee,
                              isBooking: widget.partialClinicInfo.isBooking,
                              address: ClinicAddressEntity(
                                governorate: selectedGovernorate,
                                markaz: selectedMarkaz,
                                village: selectedVillage,
                                street: streetController.text.trim(),
                                floor: floorController.text.trim(),
                                department: departmentController.text.trim(),
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
      ),
    );
  }

  @override
  void dispose() {
    streetController.dispose();
    floorController.dispose();
    departmentController.dispose();
    super.dispose();
  }
}
