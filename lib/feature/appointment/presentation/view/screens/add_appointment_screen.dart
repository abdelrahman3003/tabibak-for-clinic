import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_save.dart';
import 'package:tabibak_for_clinic/core/widgets/app_snack_bar.dart';
import 'package:tabibak_for_clinic/core/widgets/dialogs.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/manager/create_appointment/create_appointment_bloc.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/create_appoinemnt_screen/add_appointment_body.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_entity.dart';

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
  ClinicShiftEntity? selectedShift;

  @override
  void initState() {
    super.initState();
    patientNameController = TextEditingController();
    phonePhoneController = TextEditingController();
    descriptionController = TextEditingController();
    dateController = TextEditingController();
  }

  void _onDateSelected(DateTime value) {
    setState(() {
      dateTime = value;
      dateController.text = "${value.day}/${value.month}";
    });

    final selectedDayName = DateFormat('EEEE', 'en_US').format(value);

    context.read<CreateAppointmentBloc>().add(
          GetAppointmentShiftEvent(dayEn: selectedDayName),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarSave(
        text: "Add Appointment",
        onTap: () {
          final doctorId = getit<Supabase>().client.auth.currentUser!.id;

          context.read<CreateAppointmentBloc>().add(
                AddAppointmentEvent(
                  appointment: AppointmentEntity(
                    doctorId: doctorId,
                    userId: doctorId,
                    name: patientNameController.text,
                    statusId: 5,
                    phone: phonePhoneController.text,
                    appointmentDate: dateTime,
                    description: descriptionController.text,
                    appointmentMorningShiftId:
                        selectedShift?.shiftType == "morning"
                            ? selectedShift?.shiftId
                            : null,
                    appointmentEveningShiftId:
                        selectedShift?.shiftType == "evening"
                            ? selectedShift?.shiftId
                            : null,
                  ),
                ),
              );
        },
      ),
      body: BlocListener<CreateAppointmentBloc, CreateAppointmentState>(
        listener: (context, state) {
          if (state is AddAppointmentLoading) {
            Dialogs.showLoading(context);
          }

          if (state is AddAppointmentSuccess) {
            context.pop();
            context.pop();
            AppSnackBar.show(
              context: context,
              message: "Appointment added",
            );
          }

          if (state is AddAppointmentFailed) {
            context.pop();
            AppSnackBar.show(
              context: context,
              message: state.errorMessage,
            );
          }
        },
        child: AddAppointmentBody(
          nameController: patientNameController,
          descriptionController: descriptionController,
          phoneController: phonePhoneController,
          dateController: dateController,
          onDateSelected: _onDateSelected,
          onShiftSelected: (value) {
            selectedShift = value;
          },
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
