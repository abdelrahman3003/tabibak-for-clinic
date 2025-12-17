import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';

Future<String?> uploadFileSupabase({
  required String bucket,
  required String filePath,
}) async {
  final supabase = getit<Supabase>();
  final file = File(filePath);
  final fileName =
      '${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';

  final storage = supabase.client.storage.from(bucket);
  await storage.upload(fileName, file);

  return storage.getPublicUrl(fileName);
}
