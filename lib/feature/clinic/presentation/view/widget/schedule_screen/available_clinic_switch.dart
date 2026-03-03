import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/core/widgets/dialogs.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_layout/clinic_layout_bloc.dart';

class AvailableClinicSwitch extends StatefulWidget {
  const AvailableClinicSwitch({
    super.key,
    required this.clinicId,
    required this.initialValue,
  });

  final int clinicId;
  final bool initialValue;

  @override
  State<AvailableClinicSwitch> createState() => AvailableClinicSwitchState();
}

class AvailableClinicSwitchState extends State<AvailableClinicSwitch> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.initialValue;
  }

  void _showConfirmDialog(bool val) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<ClinicLayoutBloc>(),
          child: BlocConsumer<ClinicLayoutBloc, ClinicLayoutState>(
            listenWhen: (previous, current) =>
                current is ClinicAvailableSuccess ||
                current is ClinicAvailableFailed,
            listener: (_, state) {
              if (state is ClinicAvailableSuccess) {
                setState(() => isActive = val);
                Navigator.of(dialogContext).pop();
              } else if (state is ClinicAvailableFailed) {
                Navigator.of(dialogContext).pop();
              }
            },
            buildWhen: (previous, current) =>
                current is ClinicAvailableLoading ||
                current is ClinicAvailableSuccess ||
                current is ClinicAvailableFailed,
            builder: (_, state) {
              return Dialogs.alertDialog(
                context: dialogContext,
                title: AppString.changeAvailability,
                subtitle: AppString.changeAvailabilitySubtitle,
                confirmString: AppString.confirm,
                color: AppColors.primary,
                isLoading: state is ClinicAvailableLoading,
                onPressed: () {
                  context.read<ClinicLayoutBloc>().add(
                        ToggleClinicAvailableEvent(
                          clinicId: widget.clinicId,
                          isAvailable: val,
                        ),
                      );
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: isActive,
      onChanged: _showConfirmDialog,
      activeThumbColor: AppColors.primary,
    );
  }
}
