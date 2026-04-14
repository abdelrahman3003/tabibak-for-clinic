import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/services/env_service.dart';
import 'package:tabibak_for_clinic/core/services/local_notification_services.dart';
import 'package:tabibak_for_clinic/core/services/push_notification_service.dart';
import 'package:tabibak_for_clinic/core/services/subbase_service.dart';
import 'package:tabibak_for_clinic/firebase_options.dart';

import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await EasyLocalization.ensureInitialized();

  await EnvService.init();
  await SupabaseService.init();

  await PushNotificationService.init();
  await LocalNotificationServices.init();

  await initGetIt();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/langs',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}
