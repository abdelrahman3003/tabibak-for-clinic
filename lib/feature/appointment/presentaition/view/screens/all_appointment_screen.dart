import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_status_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/manager/appointment_type/appointment_type_bloc.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/view/widget/all_appointment_screen/canceled_appointment_list_states.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/view/widget/all_appointment_screen/finished_appointment_list_states.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentaition/view/widget/all_appointment_screen/upcoming_appointment_list_states.dart';

class AllAppointmentScreen extends StatefulWidget {
  const AllAppointmentScreen({super.key});

  @override
  State<AllAppointmentScreen> createState() => _AllAppointmentScreenState();
}

class _AllAppointmentScreenState extends State<AllAppointmentScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  List<AppointmentStatusEntity>? appointmentStatusList;
  List<Widget>? tabs;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    controller.addListener(() {
      if (controller.indexIsChanging) return;
      final bloc = context.read<AppointmentTypeBloc>();
      switch (controller.index) {
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
    });
  }

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
        title: const Text("Appointments"),
        leading: _backIcon(context),
        bottom: TabBar(
          controller: controller,
          tabs: const [
            Tab(text: "Upcoming"),
            Tab(text: "Completed"),
            Tab(text: "Cancelled"),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.horizontal, vertical: 5),
        child: TabBarView(
          controller: controller,
          children: tabs!,
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
}
