import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_padding.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/widgets/text_form_filed_widget.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/manager/create_appointment/create_appointment_bloc.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/create_appoinemnt_screen/add_appointment_drop_down_states.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_entity.dart';

class AddAppointmentBody extends StatelessWidget {
  const AddAppointmentBody({
    super.key,
    this.onShiftSelected,
    this.onDateSelected,
    required this.nameController,
    required this.phoneController,
    required this.descriptionController,
    required this.dateController,
  });

  final ValueChanged<ClinicShiftEntity>? onShiftSelected;
  final ValueChanged<DateTime>? onDateSelected;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController descriptionController;
  final TextEditingController dateController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormFiledWidget(
              label: "Patient Name",
              controller: nameController,
            ),
            TextFormFiledWidget(
              label: "Phone Number",
              keyboardType: TextInputType.number,
              controller: phoneController,
            ),
            TextFormFiledWidget(
              readOnly: true,
              label: "Date",
              onTap: () async {
                final dateTime = await _pickDate(context);
                if (dateTime != null) {
                  onDateSelected?.call(dateTime);
                }
              },
              controller: dateController,
            ),
            10.hBox,
            AddAppointmentDropDownStates(
              onShiftSelected: (value) {
                onShiftSelected?.call(value);
              },
            ),
            TextFormFiledWidget(
              label: "Description",
              maxLines: 3,
              controller: descriptionController,
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate != null) {
      final selectedDayName = DateFormat('EEEE', 'en_US').format(pickedDate);

      context.read<CreateAppointmentBloc>().add(
            GetAppointmentShiftEvent(dayEn: selectedDayName),
          );

      dateController.text = "${pickedDate.day}/${pickedDate.month}";

      return pickedDate;
    }
    return null;
  }
}
