import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/functions/format_time.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/manager/create_appointment/create_appointment_bloc.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/auth_dropdown.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_entity.dart';

class AddAppointmentDropDownStates extends StatefulWidget {
  final ValueChanged<ClinicShiftEntity>? onShiftSelected;

  const AddAppointmentDropDownStates({
    super.key,
    this.onShiftSelected,
  });

  @override
  State<AddAppointmentDropDownStates> createState() =>
      _AddAppointmentDropDownStatesState();
}

class _AddAppointmentDropDownStatesState
    extends State<AddAppointmentDropDownStates> {
  String? errorMessage;

  List<ClinicShiftEntity> shifts = [];

  ClinicShiftEntity? selectedShift;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAppointmentBloc, CreateAppointmentState>(
      buildWhen: (previous, current) =>
          current is GetAppointmentShiftSuccess ||
          current is GetAppointmentShiftFailed,
      builder: (context, state) {
        if (state is GetAppointmentShiftFailed) {
          errorMessage = state.errorMessage;
          shifts = [];
          selectedShift = null;
        } else if (state is GetAppointmentShiftSuccess) {
          final data = state.clinicShiftEntityList;

          if (data == null || data.isEmpty) {
            errorMessage = "This day has no shifts";
            shifts = [];
            selectedShift = null;
          } else {
            errorMessage = null;
            shifts = data;

            if (selectedShift != null &&
                !shifts.any((e) => e.shiftId == selectedShift!.shiftId)) {
              selectedShift = null;
            }
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppDropdown<ClinicShiftEntity>(
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.primary),
              items: shifts,
              value: selectedShift,
              labelBuilder: (item) =>
                  "${item.shiftType} ${formatTime(item.start!)} - ${formatTime(item.end!)}",
              validator: (item) =>
                  item == null ? "Please select a shift" : null,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedShift = value;
                  });

                  widget.onShiftSelected?.call(value);
                }
              },
              filledColor: Colors.transparent,
              hint: shifts.isEmpty ? "No shifts available" : "Select Shift",
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 5),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
