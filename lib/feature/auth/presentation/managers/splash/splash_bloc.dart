import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/usecases/get_doctor_auth_use_case.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final GetDoctorAuthUseCase getDoctorAuthUseCase;
  SplashBloc(this.getDoctorAuthUseCase) : super(SplashInitial()) {
    on<CheckDoctorEvent>((event, emit) async {
      if (event.user != null && event.user?.emailConfirmedAt != null) {
        emit(SplashLoading());
        final result = await getDoctorAuthUseCase(user: event.user!);
        result.fold(
          (l) => emit(SplashError()),
          (doctor) => emit(SplashSuccess(doctorEntity: doctor)),
        );
      } else {
        emit(const SplashSuccess());
      }
    });
    add(CheckDoctorEvent(user: Supabase.instance.client.auth.currentUser));
  }
}
