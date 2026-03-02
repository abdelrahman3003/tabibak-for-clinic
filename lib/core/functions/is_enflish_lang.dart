import 'package:flutter/material.dart';

bool isEnglishLanguage(BuildContext context) {
  return Localizations.localeOf(context).languageCode == 'en';
}
