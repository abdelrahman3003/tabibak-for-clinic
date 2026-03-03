import 'package:collection/collection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/functions/format_time.dart';
import 'package:tabibak_for_clinic/core/networking/api_consatnt.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/data_source/clinic_remote_data.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_address_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_day_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_info_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_working_day_model.dart';

class ClinicRemoteDataImpl implements ClinicRemoteData {
  final SupabaseClient supabase;

  ClinicRemoteDataImpl({
    required this.supabase,
  });

  @override
  Future<int> createClinicInfo(ClinicInfoModel model) async {
    final data = model.toJson()..['doctor_id'] = supabase.auth.currentUser!.id;

    final response =
        await supabase.from('clinic_data').insert(data).select('id').single();

    return response['id'] as int;
  }

  @override
  Future<List<ClinicDayModel>> getAllDays() async {
    final response = await supabase.from('days').select();

    final days = response as List;

    return days.map((day) => ClinicDayModel.fromJson(day)).toList();
  }

  @override
  Future<List<ClinicInfoModel>> getClinicInfo() async {
    final response = await supabase
        .from('clinic_data')
        .select('*, clinic_address(*)')
        .eq('doctor_id', supabase.auth.currentUser!.id);

    final data = response as List<dynamic>;

    return data
        .map((e) => ClinicInfoModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ClinicWorkingDayModel>> getClinicSchedule({
    required int clinicId,
  }) async {
    final response = await supabase
        .from('working_day')
        .select(ApiConstants.getWorkingShiftsDays)
        .eq('clinic_id', clinicId);

    final workingShiftsDays = response as List;

    return workingShiftsDays
        .map((e) => ClinicWorkingDayModel.fromJson(e))
        .toList();
  }

  @override
  Future<void> saveClinicInfo({
    required ClinicInfoModel clinicInfoModel,
  }) async {
    await supabase
        .from('clinic_data')
        .update(clinicInfoModel.toJson())
        .eq('id', clinicInfoModel.id!);
  }

  @override
  Future<void> saveClinicWorkingDays({
    required int clinicId,
    required List<ClinicWorkingDayModel> selectedDays,
  }) async {
    for (int dayId = 1; dayId <= 7; dayId++) {
      final selectedDay = selectedDays.firstWhereOrNull(
        (e) => e.clinicDayEntity?.id == dayId,
      );

      final isSelected = selectedDay?.isSelected ?? false;

      int? shiftMorningId;
      int? shiftEveningId;

      if (isSelected) {
        final shiftMorningResponse = await supabase
            .from('shifts_morning')
            .upsert({
              'start': formatTime(selectedDay?.clinicShiftMorningEntity!.start),
              'end': formatTime(selectedDay?.clinicShiftMorningEntity!.end),
            })
            .select()
            .single();

        shiftMorningId = shiftMorningResponse['id'];

        final shiftEveningResponse = await supabase
            .from('shift_evening')
            .upsert({
              'start': formatTime(selectedDay?.clinicShiftEveningEntity!.start),
              'end': formatTime(selectedDay?.clinicShiftEveningEntity!.end),
            })
            .select()
            .single();

        shiftEveningId = shiftEveningResponse['id'];
      }

      await supabase.from('working_day').upsert(
        {
          'clinic_id': clinicId,
          'day_id': dayId,
          'is_selected': isSelected,
          'shift_morning_id': shiftMorningId,
          'shift_evening_id': shiftEveningId,
        },
        onConflict: 'clinic_id,day_id',
      );
    }
  }

  @override
  Future<void> saveClinicAddress({
    required ClinicAddressModel clinicAddressModel,
  }) async {
    await supabase.from('clinic_address').upsert(
          clinicAddressModel.toJson(),
          onConflict: 'clinic_id',
        );
  }

  @override
  Future<void> toggleClinicAvailable({
    required int clinicId,
    required bool isAvailable,
  }) async {
    await supabase
        .from('clinic_data')
        .update({'is_available': isAvailable}).eq('id', clinicId);
  }
}
