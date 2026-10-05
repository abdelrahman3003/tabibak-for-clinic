import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/constant/app_padding.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/core/helper/shared_pref_helper.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/view/widget/doctor_profile_screen/doctor_profile_status.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/view/widget/doctor_profile_screen/edit_item.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/view/widget/doctor_profile_screen/log_out_dialog_states.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/view/widget/doctor_profile_screen/personal_image.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/view/widget/doctor_profile_screen/profile_title.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/view/widget/doctor_profile_screen/report_dialog.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/view/widget/doctor_profile_screen/setting_item.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/get_clinic_info_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/layout_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibak_for_clinic/core/widgets/route_screen_wapper.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_info/clinic_info_bloc.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/screens/clinic%20creation/clinic_structure_screen.dart';

class DoctorProfileBody extends StatelessWidget {
  const DoctorProfileBody({super.key, required this.doctor});
  final DoctorEntity doctor;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppPadding.horizontal),
      child: Column(
        children: [
          PersonalImage(
            imageUrl: doctor.image,
          ),
          14.hBox,
          Text(
            doctor.name ?? AppString.unknown,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xff1E293B),
            ),
          ),
          4.hBox,
          Text(
            doctor.email ?? AppString.unknown,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.grey,
              fontWeight: FontWeight.w400,
            ),
          ),
          10.hBox,
          DoctorProfileStatus(statusEntity: doctor.status!),
          10.hBox,
          if ((doctor.bioAr != null && doctor.bioAr!.isNotEmpty) ||
              (doctor.bioEn != null && doctor.bioEn!.isNotEmpty))
            Text(
              (context.locale.languageCode == 'ar'
                      ? doctor.bioAr
                      : doctor.bioEn) ??
                  "",
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xff475569),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          24.hBox,
          FutureBuilder(
            future: getit<GetClinicInfoUseCase>().call(),
            builder: (context, snapshot) {
              final clinics = snapshot.data?.fold<List<ClinicInfoEntity>>(
                    (_) => <ClinicInfoEntity>[],
                    (items) => items,
                  ) ??
                  <ClinicInfoEntity>[];
              if (snapshot.connectionState == ConnectionState.waiting || clinics.isEmpty) {
                return const SizedBox.shrink();
              }
              final selectedId = getit<SharedPrefHelper>().getInt(SharedPrefKeys.currentClinicId);
              final current = clinics.firstWhere((c) => c.id == selectedId, orElse: () => clinics.first);
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: OutlinedButton.icon(
                  icon: const Text('🏥'),
                  label: Text('${current.clinicName ?? 'Clinic'} ▼'),
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    builder: (sheetContext) => SafeArea(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          ...clinics.map((clinic) => ListTile(
                            title: Text(clinic.clinicName ?? 'Clinic'),
                            trailing: clinic.id == current.id ? const Icon(Icons.check) : null,
                            onTap: () async {
                              Navigator.pop(sheetContext);
                              if (clinic.id == current.id) return;
                              await getit<SharedPrefHelper>().setData(key: SharedPrefKeys.currentClinicId, value: clinic.id!);
                              if (context.mounted) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (_) => LayoutScreen(refreshKey: clinic.id!)),
                                  (route) => false,
                                );
                              }
                            },
                          )),
                          ListTile(
                            leading: const Icon(Icons.add),
                            title: const Text('+ Add New Clinic'),
                            onTap: () {
                              Navigator.pop(sheetContext);
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) => RootScreenWrapper(
                                  child: BlocProvider(
                                    create: (_) => getit<ClinicInfoBloc>(),
                                    child: const ClinicStructureScreen(),
                                  ),
                                )),
                                (route) => route.isFirst,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileTitle(
                title: context.locale.languageCode == 'ar'
                    ? 'معلومات الطبيب'
                    : 'Doctor Information',
                icon: Icons.medical_services,
              ),
              10.hBox,
              EditItem(
                title: context.locale.languageCode == 'ar'
                    ? 'المعلومات الشخصية'
                    : 'Personal Information',
                subtitle: doctor.phone ?? "",
                onTap: () {
                  context.pushNamed(Routes.doctorPersonalInfo,
                      arguments: doctor);
                },
              ),
              15.hBox,
              EditItem(
                title: context.locale.languageCode == 'ar'
                    ? 'التخصص'
                    : 'Specialty',
                subtitle: (context.locale.languageCode == 'ar'
                        ? doctor.specialtyData?.nameAr
                        : doctor.specialtyData?.nameEn) ??
                    AppString.notSpecified,
                onTap: () {
                  context.pushNamed(Routes.doctorSpecialtyScreen,
                      arguments: doctor.specialty);
                },
              ),
              15.hBox,
              EditItem(
                title: context.locale.languageCode == 'ar'
                    ? 'التعليم'
                    : 'Education',
                subtitle:
                    doctor.education?.university ?? AppString.educationIsEmpty,
                onTap: () {
                  context.pushNamed(
                    Routes.doctorEducationScreen,
                    arguments: doctor.education,
                  );
                },
              ),
              20.hBox,
              ProfileTitle(title: AppString.setting, icon: Icons.settings),
              10.hBox,
              SettingItem(
                title: AppString.aboutUs,
                icon: Icons.info_outline,
                onTap: () => _showUnavailableDialog(context, AppString.aboutUs),
              ),
              15.hBox,
              SettingItem(
                title: AppString.privacy,
                icon: Icons.privacy_tip,
                onTap: () => _showUnavailableDialog(context, AppString.privacy),
              ),
              15.hBox,
              SettingItem(
                title: context.locale.languageCode == 'ar'
                    ? 'الإبلاغ عن مشكلة'
                    : 'Report a problem',
                icon: Icons.flag_outlined,
                onTap: () => showDialog<void>(
                  context: context,
                  builder: (_) => const ReportDialog(),
                ),
              ),
              15.hBox,
              SettingItem(
                title: AppString.switchLanguage,
                icon: Icons.language,
                onTap: () {
                  context.pushNamed(Routes.languageScreen);
                },
              ),
              15.hBox,
              SettingItem(
                title: AppString.logOut,
                icon: Icons.logout,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const LogOutDialogStates(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showUnavailableDialog(BuildContext context, String title) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(
          context.locale.languageCode == 'ar'
              ? 'هذه الميزة غير متاحة حاليًا.'
              : 'This feature is not available yet.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(AppString.close),
          ),
        ],
      ),
    );
  }
}
