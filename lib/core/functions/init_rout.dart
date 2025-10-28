import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/helper/shared_pref_helper.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';

String initRout() {
  final sharedPrefHelper = getit<SharedPrefHelper>();
  if (sharedPrefHelper.getInt(SharedPrefKeys.step) == 2) {
    return Routes.homeScreen;
  }
  return Routes.singinScreen;
}
