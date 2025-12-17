import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tabibak_for_clinic/feature/appointment/appointment_screen.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/screens/clinic_layout.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/screens/doctor_profile_screen.dart';

import 'core/theme/app_colors.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;
  late final List<GButton> _tabs;

  @override
  void initState() {
    super.initState();

    _screens = [
      const ClinicLayout(),
      const AppointmentScreen(),
      const DoctorProfileScreen(),
    ];

    _tabs = [
      GButton(
        icon: Icons.calendar_today_outlined,
        text: "Clinic",
        textStyle: _tabTextStyle(),
      ),
      GButton(
        icon: Icons.event,
        text: "Appointments",
        textStyle: _tabTextStyle(),
      ),
      GButton(
        icon: Icons.person,
        text: "Profile",
        textStyle: _tabTextStyle(),
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
