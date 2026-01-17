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
        List<String> shiftItems = [];

        if (state is GetAppointmentShiftFailed) {
          errorMessage = state.errorMessage;
          shiftId = null;
        } else if (state is GetAppointmentShiftSuccess) {
          if (state.clinicShiftEntity == null) {
            errorMessage = "This day has no shifts";
            shiftId = null;
          } else {
            errorMessage = null;
            shiftItems = _getShiftList(state.clinicShiftEntity!);
            shiftId = state.clinicShiftEntity!.shiftId;
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppDropdown<String>(
              items: shiftItems,
              labelBuilder: (item) => item,
              validator: (item) =>
                  item == null ? "Please select a shift" : null,
              onChanged: (value) {
                setState(() {
                  selectedShift = value;
                });

                if (value != null && shiftId != null) {
                  widget.onShiftSelected?.call(shiftId!);
                }
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

List<String> _getShiftList(ClinicShiftEntity shift) {
  List<String> list = [];

  if (shift.morningStart != null && shift.morningEnd != null) {
    list.add(
      'Morning ${formatTime(shift.morningStart!)} - ${formatTime(shift.morningEnd!)}',
    );
  }

  if (shift.eveningStart != null && shift.eveningEnd != null) {
    list.add(
      'Evening ${formatTime(shift.eveningStart!)} - ${formatTime(shift.eveningEnd!)}',
    );
  }

  return list;
}
