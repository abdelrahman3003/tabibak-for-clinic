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
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_address/clinic_address_bloc.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_layout_screen/city_drop_down.dart';

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

  CityEntity? selectedCity;
  ClinicInfoEntity? clinicInfo;

  @override
  void initState() {
    super.initState();

    _clinicAddressController = TextEditingController();
    _streetController = TextEditingController();
    _floorController = TextEditingController();
    _departmentController = TextEditingController();

    context.read<ClinicAddressBloc>().add(const GetCitiesEvent());
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

    if (clinicInfo?.address != null && selectedCity == null) {
      selectedCity = clinicInfo!.address!.city;

      _clinicAddressController.text = clinicInfo?.address?.clinicAddress ?? '';

      _streetController.text = clinicInfo?.address?.street ?? '';

      _floorController.text = clinicInfo?.address?.floor ?? '';

      _departmentController.text = clinicInfo?.address?.department ?? '';
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
                    city: selectedCity,
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
                CityDropDown(
                  initialValue: selectedCity,
                  onChangedAddress: (value) {
                    selectedCity = value;
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
