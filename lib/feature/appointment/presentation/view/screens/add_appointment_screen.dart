import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_save.dart';
import 'package:tabibak_for_clinic/core/widgets/app_snack_bar.dart';
import 'package:tabibak_for_clinic/core/widgets/dialogs.dart';
import 'package:tabibak_for_clinic/core/widgets/text_form_filed_widget.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/manager/create_appointment/create_appointment_bloc.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/create_appoinemnt_screen/drop_down_states.dart';
import 'package:tabibak_for_clinic/layout_screen.dart';

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
  DateTime? dateTime;
  int? shiftId;
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
    return Scaffold(
      appBar: AppBarSave(
        text: "Add Appointment",
        onTap: () {
          final doctorId = getit<Supabase>().client.auth.currentUser!.id;
          context.read<CreateAppointmentBloc>().add(AddAppointmentEvent(
                  appointment: AppointmentEntity(
                doctorId: doctorId,
                userId: doctorId,
                name: patientNameController.text,
                statusId: 1,
                phone: phonePhoneController.text,
                appointmentDate: dateTime,
                description: descriptionController.text,
                appointmentShift: shiftId,
              )));
        },
      ),
      body: BlocListener<CreateAppointmentBloc, CreateAppointmentState>(
        listener: (context, state) {
          if (state is AddAppointmentLoading) {
            Dialogs.showLoading(context);
          }
          if (state is AddAppointmentSuccess) {
            context.pop();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LayoutScreen(initialIndex: 1)));
          }
          if (state is AddAppointmentFailed) {
            AppSnackBar.show(context: context, message: state.errorMessage);
            context.pop();
          }
        },
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
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
              DropDownStates(
                onShiftSelected: (value) {
                  shiftId = value;
                },
              ),
              TextFormFiledWidget(
                label: "Description",
                maxLines: 3,
                keyboardType: TextInputType.text,
                controller: descriptionController,
              ),
            ],
          ),
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

  @override
  void dispose() {
    patientNameController.dispose();
    phonePhoneController.dispose();
    dateController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
