import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_widget.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: AppString.switchLanguage),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _LanguageItem(
              title: AppString.english,
              locale: const Locale('en'),
              isSelected: context.locale.languageCode == 'en',
            ),
            const Divider(),
            _LanguageItem(
              title: AppString.arabic,
              locale: const Locale('ar'),
              isSelected: context.locale.languageCode == 'ar',
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageItem extends StatelessWidget {
  final String title;
  final Locale locale;
  final bool isSelected;

  const _LanguageItem({
    required this.title,
    required this.locale,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.primary : null,
            ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : null,
      onTap: () {
        context.setLocale(locale);
      },
    );
  }
}
