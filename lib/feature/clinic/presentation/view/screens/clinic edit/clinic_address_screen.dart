import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_save.dart';
import 'package:tabibak_for_clinic/core/widgets/dialogs.dart';
import 'package:tabibak_for_clinic/core/widgets/text_form_filed_widget.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_address_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_address/clinic_address_bloc.dart';

class ClinicAddressScreen extends StatefulWidget {
  const ClinicAddressScreen({super.key});

  @override
  State<ClinicAddressScreen> createState() => _ClinicAddressScreenState();
}

late TextEditingController _clinicAddressController;
late ClinicInfoEntity? clinicInfo;

@override
class _ClinicAddressScreenState extends State<ClinicAddressScreen> {
  @override
  void initState() {
    _clinicAddressController = TextEditingController();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    clinicInfo =
        ModalRoute.of(context)!.settings.arguments as ClinicInfoEntity?;

    _clinicAddressController.text = clinicInfo?.address?.clinicAddress ?? '';

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarSave(
          text: "Clinic Address",
          onTap: () {
            context.read<ClinicAddressBloc>().add(SaveClinicAddressEvent(
                clinicAddressEntity: ClinicAddressEntity(
                    clinicAddress: _clinicAddressController.text,
                    clinicId: clinicInfo?.id)));
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
                Dialogs.errorDialog(context, state.errorMessage);
              }
              if (state is ClinicAddressSuccess) {
                context.pushNamedAndRemoveUntil(
                    Routes.layOutScreen, (_) => false);
              }
            },
            child: Column(
              children: [
                TextFormFiledWidget(
                  label: "Clinic Address",
                  controller: _clinicAddressController,
                ),
                const TextFormFiledWidget(label: "Clinic Directions")
              ],
            ),
          ),
        ));
  }
}
