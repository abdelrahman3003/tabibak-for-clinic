import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_status_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/manager/appoinment/appointment_bloc.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/view/widget/all_appointment_screen/canceled_appointment_list_states.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/view/widget/all_appointment_screen/finished_appointment_list_states.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/view/widget/all_appointment_screen/item_bar.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/view/widget/all_appointment_screen/upcoming_appointment_list_states.dart';

class AllAppointmentScreen extends StatefulWidget {
  const AllAppointmentScreen({super.key});

  @override
  State<AllAppointmentScreen> createState() => _AllAppointmentScreenState();
}

class _AllAppointmentScreenState extends State<AllAppointmentScreen> {
  List<AppointmentStatusEntity>? appointmentStatusList;
  List<Widget>? tabs;
  int selectedIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (appointmentStatusList == null) {
      appointmentStatusList = ModalRoute.of(context)!.settings.arguments
          as List<AppointmentStatusEntity>;
      tabs = [
        UpcomingAppointmentListStates(
            appointmentStatusList: appointmentStatusList!),
        FinishedAppointmentListStates(
            appointmentStatusList: appointmentStatusList!),
        CanceledAppointmentListStates(
            appointmentStatusList: appointmentStatusList!),
      ];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Appointments",
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold, height: 24 / 32),
        ),
        leading: _backIcon(context),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.horizontal, vertical: 5),
        child: Column(
          children: [
            12.hBox,
            Container(
              decoration: BoxDecoration(
                color: const Color(0xffF3F4F6),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  ItemBar(
                    isActive: selectedIndex == 0,
                    text: "Upcoming",
                    onTa: () => _getAppointmentList(context, 0),
                  ),
                  ItemBar(
                    isActive: selectedIndex == 1,
                    text: "Completed",
                    onTa: () => _getAppointmentList(context, 1),
                  ),
                  ItemBar(
                    isActive: selectedIndex == 2,
                    text: "Cancelled",
                    onTa: () => _getAppointmentList(context, 2),
                  ),
                ],
              ),
            ),
            12.hBox,
            Expanded(
              child: tabs![selectedIndex],
            ),
          ],
        ),
      ),
    );
  }

  IconButton _backIcon(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Icon(Icons.arrow_back_ios, size: 20.h),
    );
  }

  void _getAppointmentList(BuildContext context, int index) {
    if (index < 0 || index > 2) return;
    setState(() {
      selectedIndex = index;
    });

    var bloc = context.read<AppointmentBloc>();
    switch (index) {
      case 0:
        bloc.add(GetUpcomingAppointmentsEvent());
        break;
      case 1:
        bloc.add(GetFinishedAppointmentsEvent());
        break;
      case 2:
        bloc.add(GetCanceledAppointmentsEvent());
        break;
    }
  }
}
