import 'dart:io';

import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/networking/api_consatnt.dart';
import 'package:tabibak_for_clinic/feature/auth/data/models/clinic_model.dart';
import 'package:tabibak_for_clinic/feature/auth/data/models/dotcor_model.dart';
import 'package:tabibak_for_clinic/feature/auth/data/models/shift_model.dart';
import 'package:tabibak_for_clinic/feature/auth/data/models/time_model.dart';
import 'package:tabibak_for_clinic/feature/auth/data/models/unversity_model.dart';
import 'package:tabibak_for_clinic/feature/auth/data/models/workday_model.dart';

abstract class DoctorDataSource {
  Future<int> addTime(TimeModel timeModel);
  Future<int> addShift(ShiftModel shiftModel);
  Future<int> addWorkDay(WorkingDayModel workingDayModel);
  Future<int> addClinic(ClinicModel clinicModel);
  Future<int> addDoctor(DotcorModel dotcorModel);
  Future<int> addUniversity(UnversityModel unversityModel);
  Future<String> uploadFile(String filePath);
}

class DoctorDataSourceImp implements DoctorDataSource {
  final Dio dio;
  final Supabase supabase;
  DoctorDataSourceImp(this.supabase, {required this.dio});
  @override
  Future<int> addTime(TimeModel timeModel) async {
    return await _remoteDateHandle("times", timeModel.toJson());
  }

  @override
  Future<int> addShift(ShiftModel shiftModel) async {
    return await _remoteDateHandle("shifts", shiftModel.toJson());
  }

  @override
  Future<int> addWorkDay(WorkingDayModel workingDayModel) async {
    return await _remoteDateHandle("working_day", workingDayModel.toJson());
  }

  @override
  Future<int> addClinic(ClinicModel clinicModel) async {
    return await _remoteDateHandle("clinic_data", clinicModel.toJson());
  }

  @override
  Future<int> addDoctor(DotcorModel dotcorModel) async {
    return await _remoteDateHandle("doctors", dotcorModel.toJson());
  }

  @override
  Future<int> addUniversity(UnversityModel unversityModel) async {
    return await _remoteDateHandle("university_data", unversityModel.toJson());
  }

  Future<dynamic> _remoteDateHandle(
      String method, Map<String, dynamic> data) async {
    final response = await dio
        .postUri(Uri.parse("${ApiConstants.apiBaseUrl}/$method"), data: data);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return response.data[0]['id'];
    } else {
      throw DioException(requestOptions: response.requestOptions);
    }
  }

  @override
  Future<String> uploadFile(String filePath) async {
    final file = File(filePath);
    final uniqueName =
        '${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';

    final storage = supabase.client.storage.from('profile_images');
    await storage.upload(uniqueName, file);

    final publicUrl = storage.getPublicUrl(uniqueName);
    return publicUrl;
  }
}
