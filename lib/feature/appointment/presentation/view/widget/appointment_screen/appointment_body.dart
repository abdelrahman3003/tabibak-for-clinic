import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_padding.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appointment_screen/appointment_empty.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appointment_screen/appointment_list.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appointment_screen/today_banner.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/schedule_screen/title_text_row.dart';

class AppointmentBody extends StatefulWidget {
  const AppointmentBody(
      {super.key, required this.appointmentList, required this.doctorName});
  final List<AppointmentEntity> appointmentList;
  final String doctorName;

  @override
  State<AppointmentBody> createState() => _AppointmentBodyState();
}

class _AppointmentBodyState extends State<AppointmentBody> {
  String _typeFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final filteredAppointments = _typeFilter == 'all'
        ? widget.appointmentList
        : widget.appointmentList.where((appointment) {
            final appointmentType =
                (appointment.appointmentTypeEn ?? '').trim().toLowerCase();
            if (_typeFilter == 'consultation') {
              return appointmentType == 'consultation';
            }
            return appointmentType == 'follow-up' ||
                appointmentType == 'follow up';
          }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
      child: Column(
        children: [
          TodayBanner(
            doctorName: widget.doctorName,
            appointmentLength: widget.appointmentList.length,
          ),
          32.hBox,
          TitleTextRow(
            title: AppString.appointmentsToday,
            subtitle: AppString.seeAll,
            trailingWidget: PopupMenuButton<String>(
              tooltip: 'Filter appointments',
              icon: Icon(
                Icons.filter_list_rounded,
                color: _typeFilter == 'all'
                    ? Theme.of(context).iconTheme.color
                    : Theme.of(context).colorScheme.primary,
              ),
              onSelected: (value) => setState(() => _typeFilter = value),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'all',
                  child: _buildFilterMenuItem('all', 'All'),
                ),
                PopupMenuItem(
                  value: 'consultation',
                  child: _buildFilterMenuItem(
                      'consultation', AppString.consultation),
                ),
                PopupMenuItem(
                  value: 'follow-up',
                  child: _buildFilterMenuItem('follow-up', AppString.followUp),
                ),
              ],
            ),
            onTap: () {
              context.pushNamed(
                Routes.allAppointmentScreen,
                arguments: _typeFilter,
              );
            },
          ),
          10.hBox,
          filteredAppointments.isEmpty
              ? Expanded(
                  child: AppointmentEmpty(
                    title: _typeFilter == 'all'
                        ? AppString.noAppointmentsToday
                        : 'No appointments found',
                  ),
                )
              : AppointmentList(
                  appointmentList: filteredAppointments,
                )
        ],
      ),
    );
  }

  Widget _buildFilterMenuItem(String value, String label) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        if (_typeFilter == value)
          const Icon(Icons.check_rounded, size: 18),
      ],
    );
  }
}
