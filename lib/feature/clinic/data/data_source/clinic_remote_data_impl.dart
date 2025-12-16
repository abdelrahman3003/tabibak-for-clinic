import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/functions/format_time.dart';
import 'package:tabibak_for_clinic/core/networking/api_consatnt.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/data_source/clinic_remote_data.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_day_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_info_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_working_day_model.dart';

class ClinicRemoteDataImpl implements ClinicRemoteData {
  final Dio dio;

  ClinicRemoteDataImpl({required this.dio});

  Future<int> _postAndReturnId(
      String endpoint, Map<String, dynamic> body) async {
    final response =
        await dio.post("${ApiConstants.apiBaseUrl}/$endpoint", data: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data[0]['id'];
    }
    throw Exception('Failed request on $endpoint');
  }

  @override
  Future<int> createClinicInfo(ClinicInfoModel model) async {
    final data = model.toJson();
    data["doctor_id"] = getit<Supabase>().client.auth.currentUser!.id;
    return _postAndReturnId('clinic_data', data);
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
    final response = await dio.get(
      "${ApiConstants.apiBaseUrl}/clinic_data",
      queryParameters: {
        "doctor_id": "eq.${getit<Supabase>().client.auth.currentUser!.id}",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data as List;
      List<ClinicInfoModel> list =
          data.map((e) => ClinicInfoModel.fromJson(e)).toList();
      return list;
    }
    throw Exception('Failed request on days');
  }

  @override
  Future<List<ClinicWorkingDayModel>> getClinicSchedule(
      {required int clinicId}) async {
    final response = await dio.get(
      "${ApiConstants.apiBaseUrl}/${ApiConstants.getWorkingShiftsDays}",
      queryParameters: {
        "clinic_id": "eq.$clinicId",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      log("======1$clinicId");
      final workingShiftsDays = response.data as List;
      return workingShiftsDays
          .map((workingShiftDay) =>
              ClinicWorkingDayModel.fromJson(workingShiftDay))
          .toList();
    }
    throw Exception('Failed request on days');
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

      int? shiftId;

      if (isSelected) {
        final shiftPayload = {
          'morning_start':
              formatTime(selectedDay!.clinicShiftEntity!.morningStart),
          'morning_end': formatTime(selectedDay.clinicShiftEntity!.morningEnd),
          'evening_start':
              formatTime(selectedDay.clinicShiftEntity!.eveningStart),
          'evening_end': formatTime(selectedDay.clinicShiftEntity!.eveningEnd),
        };

        final shiftResponse = await supabase
            .from('shifts')
            .upsert(shiftPayload)
            .select()
            .single();

        shiftId = shiftResponse['id'];
      }

      final payload = {
        'clinic_id': clinicId,
        'day_id': dayId,
        'is_selected': isSelected,
        'shift_id': shiftId
      };

      await supabase.from('working_day').upsert(
            payload,
            onConflict: 'clinic_id,day_id',
          );
    }
  }
}
