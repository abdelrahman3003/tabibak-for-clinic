import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_widget.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_time_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_shift/clinic_shift_bloc.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_shifts_screen/clinic_shift_button_states.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_shifts_screen/shift_day_time.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_work_day_screen/clinic_working_day_args.dart';

class ClinicShiftsTimeScreen extends StatefulWidget {
  const ClinicShiftsTimeScreen({super.key});

  @override
  State<ClinicShiftsTimeScreen> createState() => _ClinicShiftsTimeScreenState();
}

class _ClinicShiftsTimeScreenState extends State<ClinicShiftsTimeScreen> {
  TimeOfDay? startMorningTime;
  TimeOfDay? endMorningTime;
  TimeOfDay? startEveningTime;
  TimeOfDay? endEveningTime;
  @override
  Widget build(BuildContext context) {
    final clinicWorkingDayArgs =
        ModalRoute.of(context)!.settings.arguments as ClinicWorkingDayArgs;
    return Scaffold(
      appBar: const AppBarWidget(
        title: "Shift Times",
      ),
      body: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                    children: List.generate(
                  clinicWorkingDayArgs.selectedDays.length,
                  (index) => ShiftDayTime(
                    day: clinicWorkingDayArgs.selectedDays[index],
                    onStarMorningSelected: (value) => startMorningTime = value,
                    onEndMorningSelected: (value) => endMorningTime = value,
                    onStartEveningSelected: (value) => startEveningTime = value,
                    onEndEveningSelected: (value) => endEveningTime = value,
                  ),
                )),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    const Spacer(),
                    50.hBox,
                    ClinicShiftButtonStates(
                      onPressed: () {
                        context.read<ClinicShiftBloc>().add(
                              CreateClinicShiftEvent(
                                clinicId: clinicWorkingDayArgs.clinicId,
                                dayId: clinicWorkingDayArgs.selectedDays[0].id,
                                morningTime: ClinicTimeEntity(
                                    start: startMorningTime,
                                    end: endMorningTime),
                                eveningTime: ClinicTimeEntity(
                                    start: startEveningTime,
                                    end: endEveningTime),
                              ),
                            );
                      },
                    ),
                    25.hBox
                  ],
                ),
              )
            ],
          )),
    );
  }
}
