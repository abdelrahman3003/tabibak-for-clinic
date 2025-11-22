import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'core/theme/app_colors.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context)
        .textTheme
        .bodyLarge
        ?.copyWith(fontWeight: FontWeight.w500, color: AppColors.primary);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
              child: Center(child: Text("Home Screen")),
            ),
            GNav(
              gap: 12,
              activeColor: AppColors.primary,
              color: AppColors.primary,
              tabBackgroundColor: AppColors.second,
              selectedIndex: 1,
              onTabChange: (index) {},
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              tabMargin: const EdgeInsets.only(top: 4),
              tabs: [
                GButton(
                  icon: Icons.person,
                  text: "Profile",
                  textStyle: textStyle,
                ),
                GButton(
                    icon: Icons.event,
                    text: "Appointments",
                    textStyle: textStyle),
                GButton(
                  icon: Icons.calendar_today_outlined,
                  text: "Schedule",
                  textStyle: textStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
