import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_widget.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_working_day/clinic_working_day_bloc.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_work_day_screen/clinic_working_day_body.dart';

class ClinicDaysScreen extends StatelessWidget {
  const ClinicDaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: "Clinic Working Days",
      ),
      body: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
          child: BlocBuilder<ClinicWorkingDayBloc, ClinicWorkingDayState>(
            builder: (context, state) {
              return state is GetAllDaysSuccess
                  ? ClinicWorkingDayBody(days: state.days)
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            },
          )),
    );
  }
}
