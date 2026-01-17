import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/widgets/text_form_filed_widget.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/manager/create_appointment/create_appointment_bloc.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/view/widget/create_appoinemnt_screen/drop_down_states.dart';

class AddAppointmentBody extends StatefulWidget {
  const AddAppointmentBody({super.key});

  @override
  State<AddAppointmentBody> createState() => _AddAppointmentBodyState();
}

class _AddAppointmentBodyState extends State<AddAppointmentBody> {
  late TextEditingController patientNameController;
  late TextEditingController phonePhoneController;
  late TextEditingController descriptionController;
  late TextEditingController dateController;
  DateTime? dateTime;
  @override
  void initState() {
    patientNameController = TextEditingController();
    phonePhoneController = TextEditingController();
    descriptionController = TextEditingController();
    dateController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            onTap: () async {
              dateTime = await _pickDate(context);
            },
            controller: dateController,
          ),
          10.hBox,
          const DropDownStates(),
          TextFormFiledWidget(
            label: "Description",
            maxLines: 3,
            keyboardType: TextInputType.number,
            controller: descriptionController,
          ),
        ],
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
