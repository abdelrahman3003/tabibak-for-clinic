import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/constant/app_padding.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_status_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/manager/appoinment/appointment_bloc.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/all_appointment_screen/canceled_appointment_list_states.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/all_appointment_screen/finished_appointment_list_states.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/all_appointment_screen/item_bar.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/all_appointment_screen/upcoming_appointment_list_states.dart';

class AllAppointmentScreen extends StatelessWidget {
  const AllAppointmentScreen({
    super.key,
    required this.appointmentStatusList,
  });

  final List<AppointmentStatusEntity> appointmentStatusList;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      UpcomingAppointmentListStates(
          appointmentStatusList: appointmentStatusList),
      FinishedAppointmentListStates(
          appointmentStatusList: appointmentStatusList),
      CanceledAppointmentListStates(
          appointmentStatusList: appointmentStatusList),
    ];

    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppString.appointments,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold, height: 24 / 32),
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios, size: 20.h),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.horizontal, vertical: 5),
          child: BlocBuilder<AppointmentBloc, AppointmentState>(
            buildWhen: (prev, curr) => curr is ToggleIndexState,
            builder: (context, state) {
              final selectedIndex = state is ToggleIndexState ? state.index : 0;

              return Column(
                children: [
                  12.hBox,
                  _TabBar(
                    selectedIndex: selectedIndex,
                    onTabChanged: (index) => _onTabChanged(context, index),
                  ),
                  12.hBox,
                  Expanded(
                      child: IndexedStack(
                    alignment: AlignmentDirectional.topCenter,
                    index: selectedIndex,
                    children: tabs,
                  ))
                ],
              );
            },
          ),
        ));
  }

  void _onTabChanged(BuildContext context, int index) {
    final bloc = context.read<AppointmentBloc>();
    bloc.add(ChangeTabEvent(index));

    switch (index) {
      case 0:
        bloc.add(GetUpcomingAppointmentsEvent());
      case 1:
        bloc.add(GetFinishedAppointmentsEvent());
      case 2:
        bloc.add(GetCanceledAppointmentsEvent());
    }
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({
    required this.selectedIndex,
    required this.onTabChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xffF3F4F6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          ItemBar(
            isActive: selectedIndex == 0,
            text: AppString.upcoming,
            onTa: () => onTabChanged(0),
          ),
          ItemBar(
            isActive: selectedIndex == 1,
            text: AppString.completed,
            onTa: () => onTabChanged(1),
          ),
          ItemBar(
            isActive: selectedIndex == 2,
            text: AppString.cancelled,
            onTa: () => onTabChanged(2),
          ),
        ],
      ),
    );
  }
}
