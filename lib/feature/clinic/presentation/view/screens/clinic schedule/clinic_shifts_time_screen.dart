import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_padding.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
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
  const ClinicShiftsTimeScreen({super.key, required this.clinicWorkingDayArgs});
  final ClinicWorkingDayArgs clinicWorkingDayArgs;
  @override
  State<ClinicShiftsTimeScreen> createState() => _ClinicShiftsTimeScreenState();
}

class _ClinicShiftsTimeScreenState extends State<ClinicShiftsTimeScreen> {
  late List<ClinicWorkingDayModel> selectedDays;
  @override
  void initState() {
    selectedDays = widget.clinicWorkingDayArgs.selectedDays
        .map(
          (e) => ClinicWorkingDayModel(
              id: e.id,
              isSelected: e.isSelected,
              clinicDayEntity: e.clinicDayEntity,
              clinicShiftMorningEntity: e.clinicShiftMorningEntity,
              clinicShiftEveningEntity: e.clinicShiftEveningEntity),
        )
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: AppString.shiftTimes),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: List.generate(
                  widget.clinicWorkingDayArgs.selectedDays.length,
                  (index) {
                    final workingDay =
                        widget.clinicWorkingDayArgs.selectedDays[index];

                    return ShiftDayTime(
                      day: workingDay.clinicDayEntity!,
                      initialEveningStart:
                          workingDay.clinicShiftEveningEntity?.start,
                      initialEveningEnd:
                          workingDay.clinicShiftEveningEntity?.end,
                      initialMorningStart:
                          workingDay.clinicShiftMorningEntity?.start,
                      initialMorningEnd:
                          workingDay.clinicShiftMorningEntity?.end,
                      isMorningActive: selectedDays[index]
                              .clinicShiftMorningEntity
                              ?.isActive ??
                          false,
                      isEveningActive: selectedDays[index]
                              .clinicShiftEveningEntity
                              ?.isActive ??
                          false,
                      onStarMorningSelected: (value) {
                        _saveDayTime(
                          workingDay.clinicDayEntity!,
                          morningStart: value,
                          morningActive: true,
                        );
                      },
                      onEndMorningSelected: (value) {
                        _saveDayTime(
                          workingDay.clinicDayEntity!,
                          morningEnd: value,
                          morningActive: true,
                        );
                      },
                      onStartEveningSelected: (value) {
                        _saveDayTime(
                          workingDay.clinicDayEntity!,
                          eveningStart: value,
                          eveningActive: true,
                        );
                      },
                      onEndEveningSelected: (value) {
                        _saveDayTime(
                          workingDay.clinicDayEntity!,
                          eveningEnd: value,
                          eveningActive: true,
                        );
                      },
                      onMorningActiveChanged: (value) {
                        _saveDayTime(
                          workingDay.clinicDayEntity!,
                          morningActive: value,
                        );
                      },
                      onEveningActiveChanged: (value) {
                        _saveDayTime(
                          workingDay.clinicDayEntity!,
                          eveningActive: value,
                        );
                      },
                    );
                  },
                ),
              ),
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
                                widget.clinicWorkingDayArgs.clinicId,
                                selectedDays),
                          );
                    },
                  ),
                  25.hBox,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveDayTime(
    ClinicDayEntity day, {
    TimeOfDay? morningStart,
    TimeOfDay? morningEnd,
    TimeOfDay? eveningStart,
    TimeOfDay? eveningEnd,
    bool? morningActive,
    bool? eveningActive,
  }) {
    final index =
        selectedDays.indexWhere((e) => e.clinicDayEntity?.id == day.id);

    if (index == -1) {
      selectedDays.add(
        ClinicWorkingDayModel(
            clinicDayEntity: day,
            isSelected: true,
            clinicShiftMorningEntity: ClinicShiftEntity(
              start: morningStart,
              end: morningEnd,
              isActive: morningActive ?? false,
            ),
            clinicShiftEveningEntity: ClinicShiftEntity(
              start: eveningStart,
              end: eveningEnd,
              isActive: eveningActive ?? false,
            )),
      );
    } else {
      final old = selectedDays[index];
      selectedDays[index] = ClinicWorkingDayModel(
        id: old.id,
        isSelected: true,
        clinicDayEntity: day,
        clinicShiftMorningEntity: ClinicShiftEntity(
          start: morningStart ?? old.clinicShiftMorningEntity?.start,
          end: morningEnd ?? old.clinicShiftMorningEntity?.end,
          isActive: morningActive ?? old.clinicShiftMorningEntity?.isActive,
        ),
        clinicShiftEveningEntity: ClinicShiftEntity(
          start: eveningStart ?? old.clinicShiftEveningEntity?.start,
          end: eveningEnd ?? old.clinicShiftEveningEntity?.end,
          isActive: eveningActive ?? old.clinicShiftEveningEntity?.isActive,
        ),
      );
    }
    setState(() {});
  }
}
