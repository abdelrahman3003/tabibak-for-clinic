import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/helper/app_snack_bar.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_save.dart';
import 'package:tabibak_for_clinic/core/widgets/dialogs.dart';
import 'package:tabibak_for_clinic/core/widgets/text_form_filed_widget.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_address_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/city_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/governorate_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_address/clinic_address_bloc.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_layout_screen/governorate_drop_down.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_layout_screen/markaz_drop_down.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_layout_screen/village_drop_down.dart';

class ClinicAddressScreen extends StatefulWidget {
  const ClinicAddressScreen({super.key});

  @override
  State<ClinicAddressScreen> createState() => _ClinicAddressScreenState();
}

class _ClinicAddressScreenState extends State<ClinicAddressScreen> {
  late TextEditingController _clinicAddressController;
  late TextEditingController _streetController;
  late TextEditingController _floorController;
  late TextEditingController _departmentController;

  GovernorateEntity? selectedGovernorate;
  CityEntity? selectedMarkaz;
  CityEntity? selectedVillage;
  ClinicInfoEntity? clinicInfo;

  @override
  void initState() {
    super.initState();

    _clinicAddressController = TextEditingController();
    _streetController = TextEditingController();
    _floorController = TextEditingController();
    _departmentController = TextEditingController();

    context.read<ClinicAddressBloc>().add(const GetGovernoratesEvent());
  }

  @override
  void dispose() {
    _clinicAddressController.dispose();
    _streetController.dispose();
    _floorController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    clinicInfo =
        ModalRoute.of(context)!.settings.arguments as ClinicInfoEntity?;

    if (clinicInfo?.address != null && _clinicAddressController.text.isEmpty) {
      _clinicAddressController.text = clinicInfo?.address?.clinicAddress ?? '';
      _streetController.text = clinicInfo?.address?.street ?? '';
      _floorController.text = clinicInfo?.address?.floor ?? '';
      _departmentController.text = clinicInfo?.address?.department ?? '';

      selectedGovernorate = clinicInfo?.address?.governorate;
      selectedMarkaz = clinicInfo?.address?.markaz;
      selectedVillage = clinicInfo?.address?.village;
      
      if (selectedGovernorate?.id != null) {
        context.read<ClinicAddressBloc>().add(
            GetCitiesByGovernorateEvent(governorateId: selectedGovernorate!.id!));
      }
      if (selectedMarkaz?.id != null) {
        context.read<ClinicAddressBloc>().add(
            GetCitiesByParentEvent(parentId: selectedMarkaz!.id!));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarSave(
        text: AppString.clinicAddress,
        onTap: () {
          context.read<ClinicAddressBloc>().add(
                SaveClinicAddressEvent(
                  clinicAddressEntity: ClinicAddressModel(
                    clinicAddress: _clinicAddressController.text,
                    governorate: selectedGovernorate,
                    markaz: selectedMarkaz,
                    village: selectedVillage,
                    street: _streetController.text,
                    floor: _floorController.text,
                    department: _departmentController.text,
                    clinicId: clinicInfo?.id,
                  ),
                ),
              );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocListener<ClinicAddressBloc, ClinicAddressState>(
          listener: (context, state) {
            if (state is ClinicAddressLoading) {
              Dialogs.showLoading(context);
            }

            if (state is ClinicAddressFailed) {
              context.pop();
              AppSnackBar.show(
                context,
                message: state.errorMessage,
              );
            }

            if (state is ClinicAddressSuccess) {
              context.pop();
              context.pushReplacementNamed(
                Routes.layOutScreen,
                arguments: 0,
              );
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                15.hBox,
                GovernorateDropDown(
                  initialValue: selectedGovernorate,
                  onChanged: (value) {
                    setState(() {
                      selectedGovernorate = value;
                      selectedMarkaz = null;
                      selectedVillage = null;
                    });
                    if (value?.id != null) {
                      context.read<ClinicAddressBloc>().add(
                          GetCitiesByGovernorateEvent(
                              governorateId: value!.id!));
                    }
                  },
                ),
                15.hBox,
                MarkazDropDown(
                  initialValue: selectedMarkaz,
                  onChanged: (value) {
                    setState(() {
                      selectedMarkaz = value;
                      selectedVillage = null;
                    });
                    if (value?.id != null) {
                      context.read<ClinicAddressBloc>().add(
                          GetCitiesByParentEvent(parentId: value!.id!));
                    }
                  },
                ),
                15.hBox,
                VillageDropDown(
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
                  controller: _streetController,
                ),
                TextFormFiledWidget(
                  label: AppString.floor,
                  controller: _floorController,
                ),
                TextFormFiledWidget(
                  label: AppString.department,
                  controller: _departmentController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

