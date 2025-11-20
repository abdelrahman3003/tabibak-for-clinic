import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/helper/shared_pref_helper.dart';
import 'package:tabibak_for_clinic/core/networking/dio_factory.dart';
import 'package:tabibak_for_clinic/core/services/env_service.dart';
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

final getit = GetIt.instance;
Future<void> initGetIt() async {
  final dio = DioFactory.getDio();
  final sharedPreferences = await SharedPreferences.getInstance();
  final supabase = Supabase.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: EnvService.googleClientIdIos,
      serverClientId: EnvService.googleClientIdWeb,
      scopes: ['email']);

  //! External
  getit.registerLazySingleton<SharedPrefHelper>(
      () => SharedPrefHelper(sharedPreferences));
  getit.registerLazySingleton<Dio>(() => dio);
  getit.registerLazySingleton<Supabase>(() => supabase);
  getit.registerLazySingleton<GoogleSignIn>(() => googleSignIn);
  //! Auth Features

// remote data source
  getit.registerLazySingleton<AuthRemoteData>(() => AuthRemoteDataImp(
      supabase: getit<Supabase>(),
      dio: getit<Dio>(),
      googleSignIn: getit<GoogleSignIn>()));
// repos
  getit.registerLazySingleton<AuthRepo>(() => AuthRepoImp(
        authRemoteData: getit<AuthRemoteData>(),
      ));

  //usecses
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
  // Blocs
  getit.registerFactory(() => SignupBloc(
        signUpUsecase: getit<SignUpUsecase>(),
        getSpecialtiesUsecase: getit<GetSpecialtiesUsecase>(),
      ));
  getit.registerFactory(() => SigninBloc(
      signInUsecase: getit<SignInUsecase>(),
      signInWithGooglUsecase: getit<SignInWithGooglUsecase>()));
}
