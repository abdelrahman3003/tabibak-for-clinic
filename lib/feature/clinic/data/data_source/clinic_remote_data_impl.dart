import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/networking/api_consatnt.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/data_source/clinic_remote_data.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/city_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_address_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_day_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_info_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_working_day_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/governorate_model.dart';

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
    final clinicId = response['id'] as int;
    if (model.address != null) {
      final address = ClinicAddressModel.fromEntity(model.address!);

      await supabase.from('clinic_address').insert(
            address.toJson()..['clinic_id'] = clinicId,
          );
    }
    return clinicId;
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
        .select('*, clinic_address(*, governorate(*), markaz:clinic_address_markaz_id_fkey(*), village:clinic_address_village_id_fkey(*))')
        .eq('doctor_id', supabase.auth.currentUser!.id);
    final clinics = (response as List)
        .map((json) => ClinicInfoModel.fromJson(json))
        .toList();
    clinics.sort((a, b) => a.id!.compareTo(b.id!));
    return clinics;
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
    await Supabase.instance.client.functions.invoke(
      'save-clinic-working-days',
      body: {
        "clinicId": clinicId,
        "selectedDays": selectedDays.map((day) {
          final isMorningActive =
              day.clinicShiftMorningEntity?.isActive ?? false;
          final isEveningActive =
              day.clinicShiftEveningEntity?.isActive ?? false;
          return {
            "dayId": day.clinicDayEntity?.id,
            "isSelected": day.isSelected ?? false,
            "morningActive": isMorningActive,
            "morningStart": isMorningActive
                ? _formatTime(day.clinicShiftMorningEntity?.start)
                : null,
            "morningEnd": isMorningActive
                ? _formatTime(day.clinicShiftMorningEntity?.end)
                : null,
            "eveningActive": isEveningActive,
            "eveningStart": isEveningActive
                ? _formatTime(day.clinicShiftEveningEntity?.start)
                : null,
            "eveningEnd": isEveningActive
                ? _formatTime(day.clinicShiftEveningEntity?.end)
                : null,
          };
        }).toList(),
      },
    );
  }

  @override
  Future<void> saveClinicAddress({
    required ClinicAddressModel clinicAddressModel,
  }) async {
    final existing = await supabase
        .from('clinic_address')
        .select('id')
        .eq('clinic_id', clinicAddressModel.clinicId!)
        .maybeSingle();

    if (existing != null) {
      await supabase
          .from('clinic_address')
          .update(clinicAddressModel.toJson())
          .eq('clinic_id', clinicAddressModel.clinicId!);
    } else {
      await supabase
          .from('clinic_address')
          .insert(clinicAddressModel.toJson());
    }
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

  String? _formatTime(TimeOfDay? time) {
    if (time == null) return null;

    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);

    return "${dt.hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')}:00";
  }

  @override
  Future<List<CityModel>> getCities() async {
    final response = await supabase.from('city').select("*");

    final data = response as List;
    return data.map((json) => CityModel.fromJson(json)).toList();
  }

  @override
  Future<List<GovernorateModel>> getGovernorates() async {
    final response = await supabase.from('governorate').select("*");

    final data = response as List;
    return data.map((json) => GovernorateModel.fromJson(json)).toList();
  }

  @override
  Future<List<CityModel>> getCitiesByGovernorate({
    required int governorateId,
  }) async {
    final response = await supabase
        .from('city')
        .select("*")
        .eq('governorate_id', governorateId)
        .eq('type', 'markaz');

    final data = response as List;
    return data.map((json) => CityModel.fromJson(json)).toList();
  }

  @override
  Future<List<CityModel>> getCitiesByParent({
    required int parentId,
  }) async {
    final response = await supabase
        .from('city')
        .select("*")
        .eq('parent_id', parentId);

    final data = response as List;
    return data.map((json) => CityModel.fromJson(json)).toList();
  }
}
