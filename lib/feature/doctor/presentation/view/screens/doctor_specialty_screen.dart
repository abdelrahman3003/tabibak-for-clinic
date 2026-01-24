import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_save.dart';
import 'package:tabibak_for_clinic/core/widgets/app_snack_bar.dart';
import 'package:tabibak_for_clinic/core/widgets/dialogs.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/auth_dropdown.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/specialty_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/manager/doctor_specialty/doctor_specialty_bloc.dart';

class DoctorSpecialtyScreen extends StatefulWidget {
  const DoctorSpecialtyScreen({super.key});

  @override
  State<DoctorSpecialtyScreen> createState() => _DoctorSpecialtyScreenState();
}

class _DoctorSpecialtyScreenState extends State<DoctorSpecialtyScreen> {
  int? _selectedSpecialtyId;
  @override
  void didChangeDependencies() {
    if (_selectedSpecialtyId == null) {
      _selectedSpecialtyId = ModalRoute.of(context)?.settings.arguments as int?;
      super.didChangeDependencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarSave(
          text: "Doctor Specialty",
          onTap: () {
            if (_selectedSpecialtyId != null) {
              context.read<DoctorSpecialtyBloc>().add(
                  UpdateDoctorsSpecialtyEvent(
                      specialtyId: _selectedSpecialtyId!));
            }
          },
        ),
        body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
            child: BlocConsumer<DoctorSpecialtyBloc, DoctorSpecialtyState>(
              listener: (context, state) {
                if (state is DoctorUpdateSpecialtyFailed) {
                  AppSnackBar.show(
                      context: context, message: state.errorMessage);
                }
                if (state is DoctorUpdateSpecialtySuccess) {
                  context.pop();
                  context.pushNamed(Routes.layOutScreen, arguments: 2);
                }
                if (state is DoctorUpdateSpecialtyLoading) {
                  Dialogs.showLoading(context);
                }
              },
              builder: (context, state) {
                List<SpecialtyEntity> specialties = [];
                if (state is DoctorGetSpecialtiesLoading) {
                  return const Align(
                      alignment: Alignment.topCenter,
                      child: CircularProgressIndicator());
                }

                if (state is DoctorGetSpecialtiesSuccess) {
                  specialties = state.specialties;
                  return AppDropdown<SpecialtyEntity>(
                    items: specialties,
                    hint: 'Select Specialty',
                    labelBuilder: (item) => item.nameEn,
                    validator: (value) =>
                        value == null ? 'Please select a specialty' : null,
                    onChanged: (value) {
                      _selectedSpecialtyId = value?.id;
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            )));
  }
}
