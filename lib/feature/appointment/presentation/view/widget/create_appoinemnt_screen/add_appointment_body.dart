import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_padding.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/widgets/text_form_filed_widget.dart';
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
              label: AppString.patientName,
              controller: nameController,
            ),
            TextFormFiledWidget(
              label: AppString.phoneNumber,
              keyboardType: TextInputType.number,
              controller: phoneController,
            ),
            TextFormFiledWidget(
              readOnly: true,
              label: AppString.date,
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
              label: AppString.description,
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

    return pickedDate;
  }
}
