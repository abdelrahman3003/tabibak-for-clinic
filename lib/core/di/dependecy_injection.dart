import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/networking/dio_factory.dart';
import 'package:tabibak_for_clinic/feature/auth/data/data_source/auth_remote_data.dart';
import 'package:tabibak_for_clinic/feature/auth/data/data_source/doctor_data_source.dart';
import 'package:tabibak_for_clinic/feature/auth/data/repos_imp/auth_repo_imp.dart';
import 'package:tabibak_for_clinic/feature/auth/data/repos_imp/doctor_repo_imp.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/repos/auth_repo.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/repos/doctor_repo.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/usecases/add_doctor_usecase.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/usecases/sign_up_usecase.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/managers/signup/signup_bloc.dart';

final getit = GetIt.instance;
Future<void> initGetIt() async {
  final dio = DioFactory.getDio();
  final sharedPreferences = await SharedPreferences.getInstance();
  final supabase = Supabase.instance;

  //! External
  getit.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getit.registerLazySingleton<Dio>(() => dio);
  getit.registerLazySingleton<Supabase>(() => supabase);

  //! Auth Features

// remote data source
  getit.registerLazySingleton<DoctorDataSource>(
      () => DoctorDataSourceImp(getit<Supabase>(), dio: getit<Dio>()));
  getit.registerLazySingleton<AuthRemoteData>(
      () => AuthRemoteDataImp(supabase: getit<Supabase>()));
// repos
  getit.registerLazySingleton<AuthRepo>(
      () => AuthRepoImp(authRemoteData: getit<AuthRemoteData>()));
  getit.registerLazySingleton<DoctorRepo>(
      () => DoctorRepoImp(doctorDataSource: getit<DoctorDataSource>()));
  //usecses
  getit.registerLazySingleton<SignUpUsecase>(
      () => SignUpUsecase(authRepo: getit<AuthRepo>()));
  getit.registerLazySingleton<DoctorUsecase>(
      () => DoctorUsecase(doctorRepo: getit<DoctorRepo>()));
  // Blocs
  getit.registerFactory(() => SignupBloc(
      signUpUsecase: getit<SignUpUsecase>(),
      doctorUsecase: getit<DoctorUsecase>()));
}
