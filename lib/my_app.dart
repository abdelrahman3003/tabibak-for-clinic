import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

String initRout() {
  if (SharedPrefsService.prefs.getInt(SharedPrefKeys.step) == 1) {
    return Routes.layoutScreen;
  }
  return Routes.singinView;
}
