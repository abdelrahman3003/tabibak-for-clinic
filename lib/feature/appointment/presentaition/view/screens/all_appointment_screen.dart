import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllAppointmentScreen extends StatefulWidget {
  const AllAppointmentScreen({super.key});

  @override
  State<AllAppointmentScreen> createState() => _AllAppointmentScreenState();
}

class _AllAppointmentScreenState extends State<AllAppointmentScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointments"),
        leading: _backIcon(context),
        bottom: TabBar(
          controller: controller,
          labelStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(
              text: "Today",
            ),
            Tab(text: "Upcoming"),
            Tab(text: "Completed"),
            Tab(text: "Cancelled"),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: const [],
      ),
    );
  }

  IconButton _backIcon(BuildContext context) {
    return IconButton(
      onPressed: () async {
        Navigator.pop(context);
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
      ),
      icon: Icon(
        Icons.arrow_back_ios,
        size: 20.5.h,
      ),
    );
  }
}
