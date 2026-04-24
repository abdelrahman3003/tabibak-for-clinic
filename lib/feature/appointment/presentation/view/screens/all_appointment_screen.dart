import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/constant/app_padding.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/manager/all_appointment/all_appointments_bloc.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/all_appointment_screen/appointment_list_view.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/all_appointment_screen/appointment_tap_bar.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appointment_screen/appointment_empty.dart';

class AllAppointmentScreen extends StatefulWidget {
  const AllAppointmentScreen({super.key});

  @override
  State<AllAppointmentScreen> createState() => _AllAppointmentScreenState();
}

class _AllAppointmentScreenState extends State<AllAppointmentScreen> {
  @override
  void initState() {
    super.initState();
    // ✅ Load first tab on open
    context.read<AllAppointmentsBloc>().add(GetUpcomingAppointmentsEvent());
  }

  void _onTabChanged(BuildContext context, int index) {
    final bloc = context.read<AllAppointmentsBloc>();
    bloc.add(ChangeTabEvent(index));
    switch (index) {
      case 0:
        if (bloc.upcomingList.isEmpty) bloc.add(GetUpcomingAppointmentsEvent());
      case 1:
        if (bloc.finishedList.isEmpty) bloc.add(GetFinishedAppointmentsEvent());
      case 2:
        if (bloc.canceledList.isEmpty) bloc.add(GetCanceledAppointmentsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
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
          horizontal: AppPadding.horizontal,
          vertical: 5,
        ),
        child: BlocListener<AllAppointmentsBloc, AllAppointmentsState>(
          listener: (context, state) {
            if (state is UpdateAppointmentStatusSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Status updated successfully')),
              );
            } else if (state is UpdateAppointmentStatusFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: BlocBuilder<AllAppointmentsBloc, AllAppointmentsState>(
            builder: (context, state) {
              final bloc = context.read<AllAppointmentsBloc>();
              final selectedIndex = bloc.currentIndex;

              return Column(
                children: [
                  12.hBox,
                  AppointmentTapBar(
                    selectedIndex: selectedIndex,
                    onTabChanged: (index) => _onTabChanged(context, index),
                  ),
                  12.hBox,
                  Expanded(
                    child: IndexedStack(
                      index: selectedIndex,
                      children: [
                        // ✅ Each tab gets its own data from bloc cache
                        _buildTab(
                          context,
                          state,
                          AppointmentType.upcoming,
                          bloc.upcomingList,
                        ),
                        _buildTab(
                          context,
                          state,
                          AppointmentType.finished,
                          bloc.finishedList,
                        ),
                        _buildTab(
                          context,
                          state,
                          AppointmentType.canceled,
                          bloc.canceledList,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTab(
    BuildContext context,
    AllAppointmentsState state,
    AppointmentType type,
    List<AppointmentEntity> appointments,
  ) {
    // ✅ Show loader only for this tab's loading state
    if (state is AllAppointmentsLoading && state.type == type) {
      return const Center(child: CircularProgressIndicator());
    }

    // ✅ Show error only for this tab
    if (state is AllAppointmentsFailure && state.type == type) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.message, textAlign: TextAlign.center),
            12.hBox,
            ElevatedButton(
              onPressed: () {
                final bloc = context.read<AllAppointmentsBloc>();
                switch (type) {
                  case AppointmentType.upcoming:
                    bloc.add(GetUpcomingAppointmentsEvent());
                  case AppointmentType.finished:
                    bloc.add(GetFinishedAppointmentsEvent());
                  case AppointmentType.canceled:
                    bloc.add(GetCanceledAppointmentsEvent());
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return appointments.isEmpty
        ? Center(child: AppointmentEmpty(title: "No ${type.name} appointments"))
        : AppointmentListView(
            type: type,
            appointments: appointments,
          );
  }
}
