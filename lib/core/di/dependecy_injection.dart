import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabibak_for_clinic/core/networking/dio_factory.dart';

final getit = GetIt.instance;
Future<void> initGetIt() async {
  final dio = DioFactory.getDio();
  final sharedPreferences = await SharedPreferences.getInstance();

  //! External
  getit.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getit.registerLazySingleton<Dio>(() => dio);

  //! Posts Features
}
