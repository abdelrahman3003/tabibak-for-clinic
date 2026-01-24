// import 'package:flutter/material.dart';
// import 'package:tabibak_for_clinic/feature/appointment/presentaition/view/widget/appointment_screen/appointment_card.dart';

// class AppointmentTypeList extends StatelessWidget {
//   const AppointmentTypeList({super.key, required this.type});
//   final String type;
//   @override
//   Widget build(BuildContext context) {
//     final data = List.generate(4, (i) => i);
//     return ListView.separated(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       itemBuilder: (c, i) {
//         return AppointmentCard(
//           name: "محمود أحمد",
//           date: "3:00 PM",
//           status: type,
//           image: "",
//         );
//       },
//       separatorBuilder: (c, i) => const SizedBox(height: 12),
//       itemCount: data.length,
//     );
//   }
// }
