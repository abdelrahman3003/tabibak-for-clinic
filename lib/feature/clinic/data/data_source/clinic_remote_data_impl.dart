import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/networking/api_consatnt.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/data_source/clinic_remote_data.dart';
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
    log("------ remote ${model.clinicName}");
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
}
