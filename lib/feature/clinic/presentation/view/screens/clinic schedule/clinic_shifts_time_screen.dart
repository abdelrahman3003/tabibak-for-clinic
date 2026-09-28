import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_padding.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_widget.dart';
import 'package:tabibak_for_clinic/core/widgets/app_snack_bar.dart';
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
                children: selectedDays
                    .where((d) => d.isSelected == true)
                    .map((workingDay) {

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
                      isMorningActive:
                          workingDay.clinicShiftMorningEntity?.isActive ??
                              false,
                      isEveningActive:
                          workingDay.clinicShiftEveningEntity?.isActive ??
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
                  }).toList(),
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
                      final hasInvalidDay = selectedDays
                          .where((d) => d.isSelected == true)
                          .any((d) =>
                              !(d.clinicShiftMorningEntity?.isActive ??
                                  false) &&
                              !(d.clinicShiftEveningEntity?.isActive ??
                                  false));

                      if (hasInvalidDay) {
                        AppSnackBar.show(
                          context: context,
                          message: AppString.selectShift,
                        );
                        return;
                      }

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
    // Update the specific day first
    _updateDay(
      day,
      morningStart: morningStart,
      morningEnd: morningEnd,
      eveningStart: eveningStart,
      eveningEnd: eveningEnd,
      morningActive: morningActive,
      eveningActive: eveningActive,
    );

    // Auto-fill logic
    for (final otherDay in selectedDays) {
      if (otherDay.clinicDayEntity?.id == day.id) continue;

      TimeOfDay? fillMorningStart;
      TimeOfDay? fillMorningEnd;
      TimeOfDay? fillEveningStart;
      TimeOfDay? fillEveningEnd;
      bool? fillMorningActive;
      bool? fillEveningActive;

      // Only auto-fill active state if turning ON and the other day is OFF
      if (morningActive == true &&
          !(otherDay.clinicShiftMorningEntity?.isActive ?? false)) {
        fillMorningActive = true;
      }
      if (eveningActive == true &&
          !(otherDay.clinicShiftEveningEntity?.isActive ?? false)) {
        fillEveningActive = true;
      }

      // Only auto-fill times if the other day's time is null
      if (morningStart != null &&
          otherDay.clinicShiftMorningEntity?.start == null) {
        fillMorningStart = morningStart;
      }
      if (morningEnd != null &&
          otherDay.clinicShiftMorningEntity?.end == null) {
        fillMorningEnd = morningEnd;
      }
      if (eveningStart != null &&
          otherDay.clinicShiftEveningEntity?.start == null) {
        fillEveningStart = eveningStart;
      }
      if (eveningEnd != null &&
          otherDay.clinicShiftEveningEntity?.end == null) {
        fillEveningEnd = eveningEnd;
      }

      if (fillMorningStart != null ||
          fillMorningEnd != null ||
          fillEveningStart != null ||
          fillEveningEnd != null ||
          fillMorningActive != null ||
          fillEveningActive != null) {
        _updateDay(
          otherDay.clinicDayEntity!,
          morningStart: fillMorningStart,
          morningEnd: fillMorningEnd,
          eveningStart: fillEveningStart,
          eveningEnd: fillEveningEnd,
          morningActive: fillMorningActive,
          eveningActive: fillEveningActive,
        );
      }
    }

    setState(() {});
  }

  void _updateDay(
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

    if (index == -1) return;

    final old = selectedDays[index];
    selectedDays[index] = ClinicWorkingDayModel(
      id: old.id,
      isSelected: old.isSelected,
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
}
