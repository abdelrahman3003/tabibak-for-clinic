import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
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

  late final List<Widget> _screens;
  late final List<GButton> _tabs;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _screens = [
      const ClinicLayout(),
      const AppointmentScreen(),
      const DoctorProfileScreen(),
    ];

    _tabs = [
      const GButton(
        icon: Icons.home,
        iconActiveColor: AppColors.primary,
        iconColor: Colors.grey,
        text: "Clinic",
      ),
      const GButton(
        icon: Icons.event,
        iconActiveColor: AppColors.primary,
        iconColor: Colors.grey,
        text: "Appointments",
      ),
      const GButton(
        icon: Icons.person,
        iconActiveColor: AppColors.primary,
        iconColor: Colors.grey,
        text: "Profile",
      ),
    ];
  }

  TextStyle _tabTextStyle() {
    return TextStyle(
        fontWeight: FontWeight.w500, color: AppColors.primary, fontSize: 15.sp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _screens[_selectedIndex]),
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
              tabs: _tabs,
            ),
          ],
        ),
      ),
    );
  }
}
