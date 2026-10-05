import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/helper/shared_pref_helper.dart';
import 'package:tabibak_for_clinic/feature/appointment/data/data_source/appointment_remote_data.dart';
import 'package:tabibak_for_clinic/feature/appointment/data/models/appointment_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_shift_model.dart';

class AppointmentRemoteDataImp implements AppointmentRemoteData {
  final Supabase supabase;

  AppointmentRemoteDataImp({required this.supabase});

  int get _currentClinicId =>
      getit<SharedPrefHelper>().getInt(SharedPrefKeys.currentClinicId) ??
      (throw StateError('No clinic is selected'));

  Future<void> _ensureAppointmentBelongsToCurrentClinic(int appointmentId) async {
    final appointment = await supabase.client
        .from('appointments')
        .select('id')
        .eq('id', appointmentId)
        .eq('clinic_id', _currentClinicId)
        .maybeSingle();
    if (appointment == null) {
      throw StateError('Appointment does not belong to the selected clinic');
    }
  }

  @override
  Future<List<AppointmentModel>> getAppointments(
      {int? status, bool? isToday, String? name}) async {
    final clinicId =
        getit<SharedPrefHelper>().getInt(SharedPrefKeys.currentClinicId);
    if (clinicId == null) return [];

    var query = supabase.client
        .from('appointments')
        .select(
            '*,name,appointment_types(*),appointments_status(status_en,status_ar),id,appointment_date,users(image)')
        .eq('clinic_id', clinicId)
        .eq('status', status ?? 1);

    final normalizedName = name?.trim();
    if (normalizedName != null && normalizedName.isNotEmpty) {
      query = query.ilike('name', '%$normalizedName%');
    }

    final today = DateTime.now().toIso8601String().split('T').first;

    if (status == 2) {
      if (isToday == true) {
        query = query.eq('appointment_date', today);
      } else {
        query = query.gte('appointment_date', today);
      }
    }

    final response = await query
        .order('appointment_date', ascending: true)
        .order('waiting_list', ascending: true);
    final data = response as List;

    return data.map((json) => AppointmentModel.fromJson(json)).toList();
  }

  @override
  Future<void> updateAppointmentStatus({
    required int statusIndex,
    required int appointmentId,
  }) async {
    await _ensureAppointmentBelongsToCurrentClinic(appointmentId);
    await supabase.client.functions.invoke(
      'update_appointment',
      body: {
        'appointment_id': appointmentId,
        'clinic_id': _currentClinicId,
        'status': statusIndex,
      },
    );
  }

  @override
  Future<void> addAppointment(AppointmentModel appointment) async {
    await supabase.client.functions.invoke(
      'add_appoinement_doctor',
      body: appointment.toJson(),
    );
  }

  @override
  Future<List<ClinicShiftModel>?> getAppointmentShift(String dayEn) async {
    final clinicId =
        getit<SharedPrefHelper>().getInt(SharedPrefKeys.currentClinicId);
    if (clinicId == null) return null;

    final response = await supabase.client.rpc(
      'get_shift_by_day',
      params: {
        'p_day_en': dayEn,
        'p_clinic_id': clinicId,
      },
    );
    if (response == null) return null;

    if (response is! Map) return null;

    final shifts = <ClinicShiftModel>[];
    final morning = response['shifts_morning'];
    if (morning is Map) {
      shifts.add(ClinicShiftModel.fromJson({
        ...Map<String, dynamic>.from(morning),
        'shift_type': 'morning',
      }));
    }
    final evening = response['shift_evening'];
    if (evening is Map) {
      shifts.add(ClinicShiftModel.fromJson({
        ...Map<String, dynamic>.from(evening),
        'shift_type': 'evening',
      }));
    }
    shifts.sort((a, b) => a.start!.compareTo(b.start!));
    return shifts;
  }

  @override
  Future<AppointmentModel> getAppointmentDetails(int appointmentId) async {
    final clinicId = _currentClinicId;
    final response = await supabase.client.from('appointments').select('''
        *,
        appointment_types(*),
        appointments_status(status_en, status_ar, id),
        users(image, name, user_id)
      ''')
        .eq('id', appointmentId)
        .eq('clinic_id', clinicId)
        .single();

    return AppointmentModel.fromJson(response);
  }

  @override
  Future<void> setAppointmentFollowUp(
      int appointmentId, DateTime followUpDate) {
    return _setAppointmentFollowUpInClinic(appointmentId, followUpDate);
  }

  Future<void> _setAppointmentFollowUpInClinic(
      int appointmentId, DateTime followUpDate) async {
    await _ensureAppointmentBelongsToCurrentClinic(appointmentId);
    await supabase.client.functions.invoke(
      'set-follow-up',
      body: {
        'appointment_id': appointmentId,
        'clinic_id': _currentClinicId,
        'follow_up_date': followUpDate.toIso8601String(),
      },
    );
  }

  @override
  Future<void> postponeAppointment({
    required int appointmentId,
    required int positions,
  }) async {
    await _ensureAppointmentBelongsToCurrentClinic(appointmentId);
    final response = await supabase.client.functions.invoke(
      'postpone-appointment',
      body: {
        'appointment_id': appointmentId,
        'clinic_id': _currentClinicId,
        'positions': positions,
      },
    );

    if (response.status != 200) {
      final errorMsg = response.data is Map
          ? (response.data['error'] ?? 'Failed to postpone appointment')
          : 'Failed to postpone appointment';
      throw Exception(errorMsg);
    }
  }
}
