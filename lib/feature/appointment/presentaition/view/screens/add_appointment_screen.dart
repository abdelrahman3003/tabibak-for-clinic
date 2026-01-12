import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_save.dart';
import 'package:tabibak_for_clinic/core/widgets/text_form_filed_widget.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/auth_dropdown.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_entity_extention.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_type.dart';

class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({super.key});

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  late TextEditingController patientNameController;
  late TextEditingController phonePhoneController;
  late TextEditingController descriptionController;
  late TextEditingController dateController;
  ShiftType? selectedShiftType;
  ClinicShiftEntity selectedShiftEntity = ClinicShiftEntity(
    morningStart: const TimeOfDay(hour: 8, minute: 0),
    morningEnd: const TimeOfDay(hour: 12, minute: 0),
    eveningStart: const TimeOfDay(hour: 16, minute: 0),
    eveningEnd: const TimeOfDay(hour: 20, minute: 0),
  );
  List<ShiftType> shiftItems = [];
  @override
  void initState() {
    patientNameController = TextEditingController();
    phonePhoneController = TextEditingController();
    descriptionController = TextEditingController();
    dateController = TextEditingController();
    shiftItems = selectedShiftEntity.availableShiftTypes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarSave(
        text: "Add Appointment",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
        child: Column(
          children: [
            TextFormFiledWidget(
              label: "Patient Name",
              controller: patientNameController,
            ),
            TextFormFiledWidget(
              label: "Phone Number",
              keyboardType: TextInputType.number,
              controller: phonePhoneController,
            ),
            TextFormFiledWidget(
              label: "Date",
              keyboardType: TextInputType.number,
              controller: dateController,
            ),
            10.hBox,
            AppDropdown<ShiftType>(
                items: shiftItems,
                labelBuilder: (item) =>
                    item == ShiftType.morning ? "Morning" : "Evening",
                validator: (item) =>
                    item == null ? "Please select a shift" : null,
                onChanged: (value) {
                  selectedShiftType = value;
                },
                hint: "Select Shift"),
            TextFormFiledWidget(
              label: "Description",
              maxLines: 3,
              keyboardType: TextInputType.number,
              controller: descriptionController,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    patientNameController.dispose();
    phonePhoneController.dispose();
    dateController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
