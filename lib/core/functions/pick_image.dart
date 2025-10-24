import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<String?> pickImageAndGetName() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    final fileName = pickedFile.name;
    return fileName;
  } else {
    return null;
  }
}

Future<String> uploadFile(String filePath) async {
  final supabase = Supabase.instance.client;
  final file = File(filePath);
  final fileName = file.uri.pathSegments.last;
  await supabase.storage.from('Doctor_Documents').upload(fileName, file);
  final publicUrl =
      supabase.storage.from('Doctor_Documents/abdo').getPublicUrl(fileName);
  return publicUrl;
}
