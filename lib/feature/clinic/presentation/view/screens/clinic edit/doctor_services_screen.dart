import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/constant/app_padding.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_widget.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/core/widgets/app_loading_widget.dart';
import 'package:tabibak_for_clinic/core/widgets/app_snack_bar.dart';
import 'package:tabibak_for_clinic/core/widgets/text_form_filed_widget.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/doctor_service_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/doctor_services/doctor_services_bloc.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/doctor_services/doctor_services_event.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/doctor_services/doctor_services_state.dart';

class DoctorServicesScreen extends StatefulWidget {
  final ClinicInfoEntity clinicInfoEntity;

  const DoctorServicesScreen({super.key, required this.clinicInfoEntity});

  @override
  State<DoctorServicesScreen> createState() => _DoctorServicesScreenState();
}

class _DoctorServicesScreenState extends State<DoctorServicesScreen> {
  int? get _clinicId => widget.clinicInfoEntity.id;

  @override
  void initState() {
    super.initState();
    if (_clinicId != null) {
      context
          .read<DoctorServicesBloc>()
          .add(GetDoctorServicesEvent(clinicId: _clinicId!));
    }
  }

  void _openServiceModal({DoctorServiceEntity? service}) {
    if (_clinicId == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return _ServiceFormBottomSheet(
          clinicId: _clinicId!,
          existingService: service,
          onSave: (serviceEntity) {
            context.read<DoctorServicesBloc>().add(
                  SaveDoctorServiceEvent(
                    serviceEntity: serviceEntity,
                    clinicId: _clinicId!,
                  ),
                );
            Navigator.pop(modalContext);
          },
        );
      },
    );
  }

  void _confirmDelete(DoctorServiceEntity service) {
    if (service.id == null || _clinicId == null) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            AppString.deleteService,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
          ),
          content: Text(
            "${AppString.deleteServiceConfirmation}\n\n\"${service.name}\"",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                AppString.cancel,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<DoctorServicesBloc>().add(
                      DeleteDoctorServiceEvent(
                        serviceId: service.id!,
                        clinicId: _clinicId!,
                      ),
                    );
              },
              child: Text(AppString.deleteService),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: AppString.doctorServices,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
            tooltip: AppString.addService,
            onPressed: () => _openServiceModal(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(
          AppString.addService,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () => _openServiceModal(),
      ),
      body: BlocConsumer<DoctorServicesBloc, DoctorServicesState>(
        listener: (context, state) {
          if (state is DoctorServicesError) {
            AppSnackBar.show(
              context: context,
              message: state.errorMessage,
              background: Colors.redAccent,
            );
          } else if (state is DoctorServicesActionSuccess) {
            AppSnackBar.show(
              context: context,
              message: state.isDelete
                  ? AppString.serviceDeletedSuccessfully
                  : AppString.serviceSavedSuccessfully,
              background: AppColors.green,
            );
          }
        },
        builder: (context, state) {
          if (state is DoctorServicesLoading) {
            return const Center(child: AppLoadingWidget());
          }

          final services = context.read<DoctorServicesBloc>().services;

          if (services.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              if (_clinicId != null) {
                context
                    .read<DoctorServicesBloc>()
                    .add(GetDoctorServicesEvent(clinicId: _clinicId!));
              }
            },
            child: ListView.separated(
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.horizontal,
                vertical: 16.h,
              ).copyWith(bottom: 80.h),
              itemCount: services.length,
              separatorBuilder: (_, __) => 10.hBox,
              itemBuilder: (context, index) {
                final service = services[index];
                return _buildServiceCard(service);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.medical_services_outlined,
                size: 64.r,
                color: AppColors.primary,
              ),
            ),
            20.hBox,
            Text(
              AppString.noServicesAddedYet,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            10.hBox,
            Text(
              AppString.noServicesDescription,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
              textAlign: TextAlign.center,
            ),
            24.hBox,
            SizedBox(
              width: 200.w,
              child: AppButton(
                title: AppString.addService,
                onPressed: () => _openServiceModal(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(DoctorServiceEntity service) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.medical_services_outlined,
              color: AppColors.primary,
              size: 22.r,
            ),
          ),
          14.wBox,
          Expanded(
            child: Text(
              service.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            color: AppColors.primary,
            tooltip: AppString.editService,
            onPressed: () => _openServiceModal(service: service),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            color: Colors.redAccent,
            tooltip: AppString.deleteService,
            onPressed: () => _confirmDelete(service),
          ),
        ],
      ),
    );
  }
}

class _ServiceFormBottomSheet extends StatefulWidget {
  final int clinicId;
  final DoctorServiceEntity? existingService;
  final ValueChanged<DoctorServiceEntity> onSave;

  const _ServiceFormBottomSheet({
    required this.clinicId,
    this.existingService,
    required this.onSave,
  });

  @override
  State<_ServiceFormBottomSheet> createState() =>
      _ServiceFormBottomSheetState();
}

class _ServiceFormBottomSheetState extends State<_ServiceFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.existingService?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();

    final service = DoctorServiceEntity(
      id: widget.existingService?.id,
      clinicId: widget.clinicId,
      name: name,
    );

    widget.onSave(service);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingService != null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.only(
        left: AppPadding.horizontal,
        right: AppPadding.horizontal,
        top: 16.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              14.hBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? AppString.editService : AppString.addService,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              10.hBox,
              TextFormFiledWidget(
                controller: _nameController,
                label: AppString.serviceName,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return AppString.serviceNameValidator;
                  }
                  return null;
                },
              ),
              20.hBox,
              AppButton(
                title: isEditing ? AppString.editService : AppString.addService,
                onPressed: _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
