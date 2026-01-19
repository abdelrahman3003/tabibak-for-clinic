import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/functions/format_time.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/manager/create_appointment/create_appointment_bloc.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/auth_dropdown.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_entity.dart';

class DropDownStates extends StatefulWidget {
  final ValueChanged<int>? onShiftSelected;

  const DropDownStates({super.key, this.onShiftSelected});

  @override
  State<DropDownStates> createState() => _DropDownStatesState();
}

class _DropDownStatesState extends State<DropDownStates> {
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
            shiftMap = _getShiftMap(state.clinicShiftEntity!);
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppDropdown<String>(
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

Map<String, int> _getShiftMap(ClinicShiftEntity shift) {
  final map = <String, int>{};

  if (shift.morningStart != null && shift.morningEnd != null) {
    map['Morning ${formatTime(shift.morningStart!)} - ${formatTime(shift.morningEnd!)}'] =
        shift.shiftId ?? 0;
  }

  if (shift.eveningStart != null && shift.eveningEnd != null) {
    map['Evening ${formatTime(shift.eveningStart!)} - ${formatTime(shift.eveningEnd!)}'] =
        shift.shiftId ?? 0;
  }

  return map;
}
