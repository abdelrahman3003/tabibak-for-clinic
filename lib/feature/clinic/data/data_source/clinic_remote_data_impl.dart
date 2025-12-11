import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/networking/api_consatnt.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/data_source/clinic_remote_data.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_day_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_day_with_time_edit.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_day_with_time_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_info_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_time_model.dart';
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
  Future<int> createClinicTime(ClinicTimeModel model) async {
    return _postAndReturnId('times', model.toJson());
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
  Future<void> addWorkingDayWithShifts({
    required int clinicId,
    required List<ClinicDayWithTimes> days,
  }) async {
    for (final day in days) {
      int? morningTimeId;
      int? eveningTimeId;
      if (day.morningTime?.start != null && day.morningTime?.end != null) {
        morningTimeId = await createClinicTime(day.morningTime!);
      }
      if (day.eveningTime?.start != null && day.eveningTime?.end != null) {
        eveningTimeId = await createClinicTime(day.eveningTime!);
      }

      final shiftResponse = await dio.post(
        '${ApiConstants.apiBaseUrl}/shifts',
        data: {
          'morning': morningTimeId,
          'evening': eveningTimeId,
        },
      );

      final shiftId = shiftResponse.data[0]['id'];

      // 4 — Add Working Day
      await dio.post(
        '${ApiConstants.apiBaseUrl}/working_day',
        data: {
          'clinic_id': clinicId,
          'day_id': day.dayId,
          'shift_id': shiftId,
        },
      );
    }
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
  Future<void> updateWorkingDaysWithShifts({
    required int clinicId,
    required List<ClinicDayWithTimeEdit> days,
  }) async {
    for (final day in days) {
      int? morningTimeId = day.morningTimeId;
      int? eveningTimeId = day.eveningTimeId;

      if (day.morningTime != null && morningTimeId != null) {
        await dio.patch(
          '${ApiConstants.apiBaseUrl}/time?id=eq.$morningTimeId',
          data: {
            'start': day.morningTime!.start,
            'end': day.morningTime!.end,
          },
        );
      }

      if (day.eveningTime != null && eveningTimeId != null) {
        await dio.patch(
          '${ApiConstants.apiBaseUrl}/time?id=eq.$eveningTimeId',
          data: {
            'start': day.eveningTime!.start,
            'end': day.eveningTime!.end,
          },
        );
      }

      int? shiftId = day.shiftId;

      if (shiftId != null) {
        await dio.patch(
          '${ApiConstants.apiBaseUrl}/shifts?id=eq.$shiftId',
          data: {
            'morning': morningTimeId,
            'evening': eveningTimeId,
          },
        );
      }

      if (day.workingDayId != null) {
        await dio.patch(
          '${ApiConstants.apiBaseUrl}/working_day?id=eq.${day.workingDayId}',
          data: {
            'clinic_id': clinicId,
            'day_id': day.dayId,
            'shift_id': shiftId,
          },
        );
      } else {
        await dio.post(
          '${ApiConstants.apiBaseUrl}/working_day',
          data: {
            'clinic_id': clinicId,
            'day_id': day.dayId,
            'shift_id': shiftId,
          },
        );
      }
    }
  }
}
