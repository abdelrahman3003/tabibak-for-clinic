import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/functions/format_time.dart';
import 'package:tabibak_for_clinic/core/networking/api_consatnt.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/data_source/clinic_remote_data.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_address_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_day_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_info_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_working_day_model.dart';

class ClinicRemoteDataImpl implements ClinicRemoteData {
  final Dio dio;

  ClinicRemoteDataImpl({required this.dio});

  @override
  Future<int> createClinicInfo(ClinicInfoModel model) async {
    final data = model.toJson()
      ..['doctor_id'] = getit<Supabase>().client.auth.currentUser!.id;

    final response = await getit<Supabase>()
        .client
        .from('clinic_data')
        .insert(data)
        .select('id')
        .single();

    return response['id'] as int;
  }

  @override
  Future<List<ClinicDayModel>> getAllDays() async {
    final response = await dio.get("${ApiConstants.apiBaseUrl}/days");
    if (response.statusCode == 200 || response.statusCode == 201) {
      final days = response.data as List;
      return days.map((day) => ClinicDayModel.fromJson(day)).toList();
    }
    throw Exception('Failed request on days');
  }

  @override
  Future<List<ClinicInfoModel>> getClinicInfo() async {
    final client = getit<Supabase>().client;

    final response = await client
        .from('clinic_data')
        .select('*, clinic_address(*)')
        .eq('doctor_id', client.auth.currentUser!.id);

    final data = response as List<dynamic>;
    List<ClinicInfoModel> list = data
        .map((e) => ClinicInfoModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return list;
  }

  @override
  Future<List<ClinicWorkingDayModel>> getClinicSchedule(
      {required int clinicId}) async {
    final client = getit<Supabase>().client;

    final response = await client
        .from('working_day')
        .select(ApiConstants.getWorkingShiftsDays)
        .eq('clinic_id', clinicId);

    final workingShiftsDays = response as List;
    return workingShiftsDays
        .map((workingShiftDay) =>
            ClinicWorkingDayModel.fromJson(workingShiftDay))
        .toList();
  }

  @override
  Future<void> saveClinicInfo(
      {required ClinicInfoModel clinicInfoModel}) async {
    final data = clinicInfoModel.toJson();
    final response = await dio.patch(
      "${ApiConstants.apiBaseUrl}/clinic_data",
      data: data,
      queryParameters: {"id": "eq.${clinicInfoModel.id}"},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    }
    throw Exception('Failed request on days');
  }

  @override
  Future<void> saveClinicWorkingDays({
    required int clinicId,
    required List<ClinicWorkingDayModel> selectedDays,
  }) async {
    final supabase = Supabase.instance.client;

    for (int dayId = 1; dayId <= 7; dayId++) {
      final selectedDay = selectedDays.firstWhereOrNull(
        (e) => e.clinicDayEntity?.id == dayId,
      );

      final isSelected = selectedDay?.isSelected ?? false;

      int? shiftMorningId;
      int? shiftEveningId;

      if (isSelected) {
        final shiftMorningPayload = {
          'start': formatTime(selectedDay!.clinicShiftMorningEntity!.start),
          'end': formatTime(selectedDay.clinicShiftMorningEntity!.end),
        };
        final shiftEveningPayload = {
          'start': formatTime(selectedDay.clinicShiftEveningEntity!.start),
          'end': formatTime(selectedDay.clinicShiftEveningEntity!.end),
        };

        final shiftMorningResponse = await supabase
            .from('shifts_morning')
            .upsert(shiftMorningPayload)
            .select()
            .single();

        shiftMorningId = shiftMorningResponse['id'];

        final shiftEveningResponse = await supabase
            .from('shift_evening')
            .upsert(shiftEveningPayload)
            .select()
            .single();

        shiftEveningId = shiftEveningResponse['id'];
      }

      final payload = {
        'clinic_id': clinicId,
        'day_id': dayId,
        'is_selected': isSelected,
        'shift_morning_id': shiftMorningId,
        'shift_evening_id': shiftEveningId
      };

      await supabase.from('working_day').upsert(
            payload,
            onConflict: 'clinic_id,day_id',
          );
    }
  }

  @override
  Future<void> saveClinicAddress({
    required ClinicAddressModel clinicAddressModel,
  }) async {
    await getit<Supabase>().client.from('clinic_address').upsert(
          clinicAddressModel.toJson(),
          onConflict: 'clinic_id',
        );
  }
}
