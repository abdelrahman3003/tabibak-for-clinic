import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/helper/shared_pref_helper.dart';
import 'package:tabibak_for_clinic/core/networking/dio_factory.dart';
import 'package:tabibak_for_clinic/feature/auth/data/data_source/auth_remote_data.dart';
import 'package:tabibak_for_clinic/feature/auth/data/data_source/auth_remote_data_imp.dart';
import 'package:tabibak_for_clinic/feature/auth/data/repos_imp/auth_repo_imp.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/repos/auth_repo.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/usecases/get_specialties_usecase.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/usecases/sign_in_usecase.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/usecases/sign_in_with_googl_usecase.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/usecases/sign_up_usecase.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/managers/sign_in_bloc/signin_bloc.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/managers/sign_up_bloc/signup_bloc.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/data_source/clinic_remote_data.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/data_source/clinic_remote_data_impl.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/repos_impl/clinic_repo_impl.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/repos/clinic_repo.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/create_clinic_info_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/get_clinic_info_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/get_clinic_working_day_shift_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/get_days_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/save_clinic_info_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/save_clinic_working_day_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_info/clinic_info_bloc.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_info_save/clinic_info_save_bloc.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_layout/clinic_layout_bloc.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_schedule_update/clinic_schedule_update_bloc.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_shift/clinic_shift_bloc.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_working_day/clinic_working_day_bloc.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/data_source/doctor_profile_remote_data.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/data_source/doctor_profile_remote_data_impl.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/repo_imp/doctor_profile_repo_imp.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/repos/doctor_profile_repo.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/usecase/get_doctor_use_case.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/usecase/upload_image_profile_use_case.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/manager/doctor_profile/doctor_profile_bloc.dart';

final getit = GetIt.instance;
Future<void> initGetIt() async {
  final dio = DioFactory.getDio();
  final sharedPreferences = await SharedPreferences.getInstance();
  final supabase = Supabase.instance;

  //! External
  getit.registerLazySingleton<SharedPrefHelper>(
      () => SharedPrefHelper(sharedPreferences));
  getit.registerLazySingleton<Dio>(() => dio);
  getit.registerLazySingleton<Supabase>(() => supabase);

  //! Auth Features

// remote data source
  getit.registerLazySingleton<AuthRemoteData>(() => AuthRemoteDataImp(
        supabase: getit<Supabase>(),
        dio: getit<Dio>(),
      ));
// repos
  getit.registerLazySingleton<AuthRepo>(() => AuthRepoImp(
        authRemoteData: getit<AuthRemoteData>(),
      ));

  //useCases
  getit.registerLazySingleton<SignUpUsecase>(
      () => SignUpUsecase(authRepo: getit<AuthRepo>()));
  getit
      .registerLazySingleton<GetSpecialtiesUsecase>(() => GetSpecialtiesUsecase(
            authRepo: getit<AuthRepo>(),
          ));
  getit.registerLazySingleton<SignInUsecase>(() => SignInUsecase(
        authRepo: getit<AuthRepo>(),
      ));
  getit.registerLazySingleton<SignInWithGooglUsecase>(
      () => SignInWithGooglUsecase(
            authRepo: getit<AuthRepo>(),
          ));
  // blocs
  getit.registerFactory(() => SignupBloc(
        signUpUsecase: getit<SignUpUsecase>(),
        getSpecialtiesUsecase: getit<GetSpecialtiesUsecase>(),
      ));
  getit.registerFactory(() => SigninBloc(
      signInUsecase: getit<SignInUsecase>(),
      signInWithGooglUsecase: getit<SignInWithGooglUsecase>()));

  //! Clinic Feature
// remote data source
  getit.registerLazySingleton<ClinicRemoteData>(
      () => ClinicRemoteDataImpl(dio: dio));

  //repos
  getit.registerLazySingleton<ClinicRepo>(
      () => ClinicRepoImpl(clinicRemoteData: getit<ClinicRemoteData>()));

  //useCases
  getit.registerLazySingleton<CreateClinicInfoUseCase>(
      () => CreateClinicInfoUseCase(clinicRepo: getit<ClinicRepo>()));

  getit.registerLazySingleton<GetDaysUseCase>(
      () => GetDaysUseCase(clinicRepo: getit<ClinicRepo>()));

  getit.registerLazySingleton<GetClinicInfoUseCase>(
      () => GetClinicInfoUseCase(clinicRepo: getit<ClinicRepo>()));
  getit.registerLazySingleton<GetClinicWorkingDayShiftUseCase>(
      () => GetClinicWorkingDayShiftUseCase(clinicRepo: getit<ClinicRepo>()));
  getit.registerLazySingleton<SaveClinicInfoUseCase>(
      () => SaveClinicInfoUseCase(clinicRepo: getit<ClinicRepo>()));
  getit.registerLazySingleton<SaveClinicWorkingDayUseCase>(
      () => SaveClinicWorkingDayUseCase(clinicRepo: getit<ClinicRepo>()));
  // blocs
  getit.registerFactory(() => ClinicInfoBloc(getit<CreateClinicInfoUseCase>()));
  getit.registerFactory(
      () => ClinicWorkingDayBloc(getDaysUseCase: getit<GetDaysUseCase>()));
  getit.registerFactory(
      () => ClinicShiftBloc(getit<SaveClinicWorkingDayUseCase>()));
  getit.registerFactory(() => ClinicLayoutBloc(
        getit<GetClinicInfoUseCase>(),
        getit<GetClinicWorkingDayShiftUseCase>(),
      ));
  getit.registerFactory(
      () => ClinicInfoSaveBloc(getit<SaveClinicInfoUseCase>()));
  getit.registerFactory(
      () => ClinicScheduleUpdateBloc(getit<SaveClinicWorkingDayUseCase>()));

  //! Doctor Feature
  // remote data source
  getit.registerLazySingleton<DoctorProfileRemoteData>(
      () => DoctorProfileRemoteDataImpl(supabase: getit<Supabase>()));

  // repos
  getit.registerLazySingleton<DoctorProfileRepo>(() => DoctorProfileRepoImp(
      doctorProfileRemoteData: getit<DoctorProfileRemoteData>()));

  //useCases
  getit.registerLazySingleton<GetDoctorUseCase>(
      () => GetDoctorUseCase(doctorProfileRepo: getit<DoctorProfileRepo>()));
  getit.registerLazySingleton<UploadImageProfileUseCase>(() =>
      UploadImageProfileUseCase(doctorProfileRepo: getit<DoctorProfileRepo>()));

  //blocs
  getit.registerFactory(
    () => DoctorProfileBloc(
        getit<GetDoctorUseCase>(), getit<UploadImageProfileUseCase>()),
  );
}
