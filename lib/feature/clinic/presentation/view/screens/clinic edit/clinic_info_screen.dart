import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_save.dart';
import 'package:tabibak_for_clinic/core/widgets/dialogs.dart';
import 'package:tabibak_for_clinic/core/widgets/text_form_filed_widget.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_creation/clinic_info_save/clinic_info_save_bloc.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_structure_screen/%20clinic_is_online.dart';

class ClinicInfoScreen extends StatefulWidget {
  const ClinicInfoScreen({super.key});

  @override
  State<ClinicInfoScreen> createState() => _ClinicInfoScreenState();
}

class _ClinicInfoScreenState extends State<ClinicInfoScreen> {
  late int id;
  late bool isOnline;
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
    id = clinicInfo.id ?? 0;
    isOnline = clinicInfo.isBooking ?? false;
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
          onTap: () {
            context.read<ClinicInfoSaveBloc>().add(SaveClinicInfoEvent(
                  clinicInfoEntity: ClinicInfoEntity(
                    id: id,
                    clinicName: _clinicNameController.text,
                    phoneNumber: _phoneController.text,
                    consultationFee: int.tryParse(_feeController.text),
                    isBooking: isOnline,
                  ),
                ));
          },
        ),
        body: BlocListener<ClinicInfoSaveBloc, ClinicInfoSaveState>(
          listener: (context, state) {
            if (state is ClinicInfoSaveLoading) {
              Dialogs.showLoading(context);
            }
            if (state is ClinicInfoSaveSuccess) {
              context.pushNamedAndRemoveUntil(
                  Routes.layOutScreen, (_) => false);
            }
          },
          child: Padding(
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
                ClinicIsOnline(
                  value: isOnline,
                  onChanged: (value) {
                    setState(() {
                      isOnline = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
