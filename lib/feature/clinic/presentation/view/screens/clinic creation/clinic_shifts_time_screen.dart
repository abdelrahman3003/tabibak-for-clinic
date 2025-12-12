import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_widget.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_day_with_time_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_time_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_shift/clinic_shift_bloc.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_shifts_screen/clinic_shift_button_states.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_shifts_screen/shift_day_time.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_work_day_screen/clinic_working_day_args.dart';

class ClinicShiftsTimeScreen extends StatefulWidget {
  const ClinicShiftsTimeScreen({super.key});

  @override
  State<ClinicShiftsTimeScreen> createState() => _ClinicShiftsTimeScreenState();
}

List<ClinicDayWithTimesModel> selectedDays = [];

class _ClinicShiftsTimeScreenState extends State<ClinicShiftsTimeScreen> {
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
                        clinicWorkingDayArgs.selectedDays.length, (index) {
                  final day = clinicWorkingDayArgs.selectedDays[index];
                  return ShiftDayTime(
                    day: day,
                    onStarMorningSelected: (value) {
                      _saveDayTime(day.id, morningStart: value);
                    },
                    onEndMorningSelected: (value) {
                      _saveDayTime(day.id, morningEnd: value);
                    },
                    onStartEveningSelected: (value) {
                      _saveDayTime(day.id, eveningStart: value);
                    },
                    onEndEveningSelected: (value) {
                      _saveDayTime(day.id, eveningEnd: value);
                    },
                  );
                })),
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
                                  clinicWorkingDayArgs.clinicId, selectedDays),
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

  void _saveDayTime(
    int dayId, {
    TimeOfDay? morningStart,
    TimeOfDay? morningEnd,
    TimeOfDay? eveningStart,
    TimeOfDay? eveningEnd,
  }) {
    final index = selectedDays.indexWhere((e) => e.dayId == dayId);

    if (index == -1) {
      selectedDays.add(
        ClinicDayWithTimesModel(
          dayId: dayId,
          morningTime: ClinicTimeModel(
            start: morningStart,
            end: morningEnd,
          ),
          eveningTime: ClinicTimeModel(
            start: eveningStart,
            end: eveningEnd,
          ),
        ),
      );
    } else {
      final old = selectedDays[index];
      selectedDays[index] = ClinicDayWithTimesModel(
        dayId: dayId,
        morningTime: ClinicTimeModel(
          start: morningStart ?? old.morningTime?.start,
          end: morningEnd ?? old.morningTime?.end,
        ),
        eveningTime: ClinicTimeModel(
          start: eveningStart ?? old.eveningTime?.start,
          end: eveningEnd ?? old.eveningTime?.end,
        ),
      );
    }
  }
}
