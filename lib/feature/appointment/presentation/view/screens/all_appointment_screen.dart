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
  const AllAppointmentScreen({super.key, this.initialTypeFilter = 'all'});
  final String initialTypeFilter;

  @override
  State<AllAppointmentScreen> createState() => _AllAppointmentScreenState();
}

class _AllAppointmentScreenState extends State<AllAppointmentScreen> {
  late final TextEditingController _searchController;
  String _typeFilter = 'all';

  @override
  void initState() {
    super.initState();
    final bloc = context.read<AllAppointmentsBloc>();
    _searchController = TextEditingController(text: bloc.searchName);
    _typeFilter = widget.initialTypeFilter;
    bloc.add(RefreshAllAppointmentsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh when returning from appointment details while this screen is kept
    // in the navigation stack.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AllAppointmentsBloc>().add(RefreshAllAppointmentsEvent());
      }
    });
  }

  void _onTabChanged(BuildContext context, int index) {
    final bloc = context.read<AllAppointmentsBloc>();
    bloc.add(ChangeTabEvent(index));
    bloc.add(SearchAppointmentsEvent(bloc.searchName));
  }

  void _searchAppointments([String? value]) {
    context
        .read<AllAppointmentsBloc>()
        .add(SearchAppointmentsEvent(value ?? _searchController.text));
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
                  TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: _searchAppointments,
                    decoration: InputDecoration(
                      hintText: 'Search appointments by name',
                      prefixIcon: PopupMenuButton<String>(
                        tooltip: 'Filter appointments',
                        icon: Icon(
                          Icons.filter_list_rounded,
                          color: _typeFilter == 'all'
                              ? Theme.of(context).iconTheme.color
                              : Theme.of(context).colorScheme.primary,
                        ),
                        onSelected: (value) =>
                            setState(() => _typeFilter = value),
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'all', child: Text('All')),
                          PopupMenuItem(
                            value: 'consultation',
                            child: Text(AppString.consultation),
                          ),
                          PopupMenuItem(
                            value: 'follow-up',
                            child: Text(AppString.followUp),
                          ),
                        ],
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Search',
                            icon: const Icon(Icons.search),
                            onPressed: () => _searchAppointments(),
                          ),
                          IconButton(
                            tooltip: 'Clear search',
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _searchController.clear();
                              _searchAppointments('');
                            },
                          ),
                        ],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      isDense: true,
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                          start: 12, top: 6),
                      child: Text(
                        _typeFilter == 'consultation'
                            ? AppString.consultation
                            : _typeFilter == 'follow-up'
                                ? AppString.followUp
                                : 'All appointments',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                  12.hBox,
                  Expanded(
                    child: IndexedStack(
                      index: selectedIndex,
                      children: [
                        _buildTab(
                          context,
                          state,
                          AppointmentType.upcoming,
                          selectedIndex == 0 && bloc.searchName.isNotEmpty
                              ? bloc.searchResults ?? []
                              : bloc.upcomingList,
                        ),
                        _buildTab(
                          context,
                          state,
                          AppointmentType.finished,
                          selectedIndex == 1 && bloc.searchName.isNotEmpty
                              ? bloc.searchResults ?? []
                              : bloc.finishedList,
                        ),
                        _buildTab(
                          context,
                          state,
                          AppointmentType.canceled,
                          selectedIndex == 2 && bloc.searchName.isNotEmpty
                              ? bloc.searchResults ?? []
                              : bloc.canceledList,
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

  Widget _buildTab(BuildContext context, AllAppointmentsState state,
      AppointmentType type, List<AppointmentEntity> appointments) {
    if (state is AllAppointmentsLoading && state.type == type) {
      return const Center(child: CircularProgressIndicator());
    }

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

    final searchTerm = _searchController.text.trim().toLowerCase();
    final visibleAppointments = searchTerm.isEmpty
        ? appointments
        : appointments.where((appointment) {
            final patientName = appointment.name?.trim().toLowerCase() ?? '';
            return patientName.contains(searchTerm);
          }).toList();
    final typeFilteredAppointments = _typeFilter == 'all'
        ? visibleAppointments
        : visibleAppointments.where((appointment) {
            final appointmentType =
                (appointment.appointmentTypeEn ?? '').trim().toLowerCase();
            if (_typeFilter == 'consultation') {
              return appointmentType == 'consultation';
            }
            return appointmentType == 'follow-up' ||
                appointmentType == 'follow up';
          }).toList();

    return typeFilteredAppointments.isEmpty
        ? Center(
            child: searchTerm.isNotEmpty || _typeFilter != 'all'
                ? const Text('No appointments found')
                : AppointmentEmpty(title: "No ${type.name} appointments"),
          )
        : AppointmentListView(
            type: type,
            appointments: typeFilteredAppointments,
          );
  }
}
