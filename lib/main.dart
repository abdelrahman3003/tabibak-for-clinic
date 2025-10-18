import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/services/env_service.dart';
import 'package:tabibak_for_clinic/core/services/subbase_service.dart';
import 'package:tabibak_for_clinic/my_app.dart';

void main() async {
  await EnvService.init();
  await SupabaseService.init();
  runApp(const MyApp());
}
