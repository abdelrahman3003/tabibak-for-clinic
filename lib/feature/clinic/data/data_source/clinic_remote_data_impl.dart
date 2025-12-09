import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/networking/api_consatnt.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/data_source/clinic_remote_data.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_day_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_info_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_shift_model.dart';
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
  Future<int> createClinicWorkingDay(ClinicWorkingDayModel model) async {
    return _postAndReturnId('working_day', model.toJson());
  }

  @override
  Future<int> createClinicShift(ClinicShiftModel model) async {
    return _postAndReturnId('shifts', model.toJson());
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
  Future<void> addWorkingDayWithShifts(
      {required int dayId,
      required ClinicTimeModel morningTimeModel,
      required ClinicTimeModel eveningTimeModel,
      required int clinicId}) async {
    log("------- 11");
    final morningTimeId = await createClinicTime(morningTimeModel);
    log("------- 22");

    final eveningTimeId = await createClinicTime(morningTimeModel);
    log("------- 33");

    final shiftDayResponse = await dio.post(
      '${ApiConstants.apiBaseUrl}/shifts',
      data: {
        'morning': morningTimeId,
        'evening': eveningTimeId,
      },
    );
    log("------- 44");

    final shiftDayId = await shiftDayResponse.data[0]['id'];
    log("------- 55");

    await dio.post(
      '${ApiConstants.apiBaseUrl}/working_day',
      data: {
        'clinic_id': clinicId,
        'day_id': dayId,
        'shift_id': shiftDayId,
      },
    );
    log("------- 66");
  }
}
