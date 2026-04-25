import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/functions/format_time.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/manager/create_appointment/create_appointment_bloc.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/auth_dropdown.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_entity.dart';

class AddAppointmentDropDownStates extends StatefulWidget {
  final ValueChanged<int>? onShiftSelected;

  const AddAppointmentDropDownStates({super.key, this.onShiftSelected});

  @override
  State<AddAppointmentDropDownStates> createState() =>
      _AddAppointmentDropDownStatesState();
}

class _AddAppointmentDropDownStatesState
    extends State<AddAppointmentDropDownStates> {
  String? selectedShift;
  String? errorMessage;
  int? shiftId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAppointmentBloc, CreateAppointmentState>(
      buildWhen: (previous, current) =>
          current is GetAppointmentShiftSuccess ||
          current is GetAppointmentShiftFailed,
      builder: (context, state) {
        Map<String, int> shiftMap = {};

        if (state is GetAppointmentShiftFailed) {
          errorMessage = state.errorMessage;
          shiftId = null;
        } else if (state is GetAppointmentShiftSuccess) {
          if (state.clinicShiftEntity == null) {
            errorMessage = "This day has no shifts";
            shiftId = null;
          } else {
            errorMessage = null;
            shiftMap = _getShiftMap(
              shiftMorning: state.clinicShiftEntity!,
              shiftEvening: state.clinicShiftEntity!,
            );
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppDropdown<String>(
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.primary),
              items: shiftMap.keys.toList(),
              labelBuilder: (item) => item,
              validator: (item) =>
                  item == null ? "Please select a shift" : null,
              onChanged: (value) {
                if (value != null) {
                  shiftId = shiftMap[value];
                  widget.onShiftSelected?.call(shiftId!);
                }
                setState(() {
                  selectedShift = value;
                });
              },
              filledColor: Colors.transparent,
              hint: "Select Shift",
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 5),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}

Map<String, int> _getShiftMap(
    {required ClinicShiftEntity shiftMorning,
    required ClinicShiftEntity shiftEvening}) {
  final map = <String, int>{};

  if (shiftMorning.start != null && shiftMorning.end != null) {
    map['Morning ${formatTime(shiftMorning.start!)} - ${formatTime(shiftMorning.start!)}'] =
        shiftMorning.shiftId ?? 0;
  }

  if (shiftEvening.start != null && shiftEvening.end != null) {
    map['Evening ${formatTime(shiftEvening.start!)} - ${formatTime(shiftEvening.start!)}'] =
        shiftEvening.shiftId ?? 0;
  }

  return map;
}
