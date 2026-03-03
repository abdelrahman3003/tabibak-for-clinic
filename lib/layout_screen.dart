import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/screens/appointment_screen.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/screens/clinic_layout.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/view/screens/doctor_profile_screen.dart';

import 'core/theme/app_colors.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key, this.initialIndex = 0});
  final int initialIndex;
  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const ClinicLayout(),
      const AppointmentScreen(),
      const DoctorProfileScreen(),
    ];

    final List<GButton> tabs = [
      GButton(
        icon: Icons.home,
        iconActiveColor: AppColors.primary,
        iconColor: Colors.grey,
        text: AppString.clinic,
      ),
      GButton(
        icon: Icons.event,
        iconActiveColor: AppColors.primary,
        iconColor: Colors.grey,
        text: AppString.appointments,
      ),
      GButton(
        icon: Icons.person,
        iconActiveColor: AppColors.primary,
        iconColor: Colors.grey,
        text: AppString.profile,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: screens[_selectedIndex]),
            GNav(
              gap: 12,
              activeColor: AppColors.primary,
              color: AppColors.primary,
              tabBackgroundColor: AppColors.second,
              selectedIndex: _selectedIndex,
              textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary),
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              tabMargin: const EdgeInsets.only(top: 4),
              tabs: tabs,
            ),
          ],
        ),
      ),
    );
  }
}
