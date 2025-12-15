import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_widget.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_working_day_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_day_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_shift/clinic_shift_bloc.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_shifts_screen/clinic_shift_button_states.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_shifts_screen/shift_day_time.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_work_day_screen/clinic_working_day_args.dart';

class ClinicShiftsTimeScreen extends StatefulWidget {
  const ClinicShiftsTimeScreen({super.key});

  @override
  State<ClinicShiftsTimeScreen> createState() => _ClinicShiftsTimeScreenState();
}

List<ClinicWorkingDayModel> selectedDays = [];

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
                  final workingDay = clinicWorkingDayArgs.selectedDays[index];
                  return ShiftDayTime(
                    day: workingDay.clinicDayEntity!,
                    initialMorningStart:
                        workingDay.clinicShiftEntity?.morningStart,
                    initialMorningEnd: workingDay.clinicShiftEntity?.morningEnd,
                    initialEveningStart:
                        workingDay.clinicShiftEntity?.eveningStart,
                    initialEveningEnd: workingDay.clinicShiftEntity?.eveningEnd,
                    onStarMorningSelected: (value) {
                      _saveDayTime(workingDay.clinicDayEntity!,
                          morningStart: value);
                    },
                    onEndMorningSelected: (value) {
                      _saveDayTime(workingDay.clinicDayEntity!,
                          morningEnd: value);
                    },
                    onStartEveningSelected: (value) {
                      _saveDayTime(workingDay.clinicDayEntity!,
                          eveningStart: value);
                    },
                    onEndEveningSelected: (value) {
                      _saveDayTime(workingDay.clinicDayEntity!,
                          eveningEnd: value);
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
    ClinicDayEntity day, {
    TimeOfDay? morningStart,
    TimeOfDay? morningEnd,
    TimeOfDay? eveningStart,
    TimeOfDay? eveningEnd,
  }) {
    final index =
        selectedDays.indexWhere((e) => e.clinicDayEntity?.id == day.id);

    if (index == -1) {
      selectedDays.add(
        ClinicWorkingDayModel(
          clinicDayEntity: day,
          clinicShiftEntity: ClinicShiftEntity(
            morningStart,
            morningEnd,
            eveningStart,
            eveningEnd,
          ),
        ),
      );
    } else {
      final old = selectedDays[index];

      selectedDays[index] = ClinicWorkingDayModel(
        id: old.id,
        isSelected: true,
        clinicDayEntity: day,
        clinicShiftEntity: ClinicShiftEntity(
          morningStart ?? old.clinicShiftEntity?.morningStart,
          morningEnd ?? old.clinicShiftEntity?.morningEnd,
          eveningStart ?? old.clinicShiftEntity?.eveningStart,
          eveningEnd ?? old.clinicShiftEntity?.eveningEnd,
        ),
      );
    }
  }
}
