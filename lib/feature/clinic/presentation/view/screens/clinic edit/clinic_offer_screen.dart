import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/constant/app_padding.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_save.dart';
import 'package:tabibak_for_clinic/core/widgets/app_loading_widget.dart';
import 'package:tabibak_for_clinic/core/widgets/app_snack_bar.dart';
import 'package:tabibak_for_clinic/core/widgets/text_form_filed_widget.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/offer_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_offer/clinic_offer_bloc.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_offer/clinic_offer_event.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/clinic_offer/clinic_offer_state.dart';

class ClinicOfferScreen extends StatefulWidget {
  final ClinicInfoEntity clinicInfoEntity;

  const ClinicOfferScreen({super.key, required this.clinicInfoEntity});

  @override
  State<ClinicOfferScreen> createState() => _ClinicOfferScreenState();
}

class _ClinicOfferScreenState extends State<ClinicOfferScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleArController;
  late TextEditingController _titleEnController;
  late TextEditingController _detailsArController;
  late TextEditingController _detailsEnController;
  late TextEditingController _discountController;

  int? _existingOfferId;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isActive = true;
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _titleArController = TextEditingController();
    _titleEnController = TextEditingController();
    _detailsArController = TextEditingController();
    _detailsEnController = TextEditingController();
    _discountController = TextEditingController();

    if (widget.clinicInfoEntity.id != null) {
      context
          .read<ClinicOfferBloc>()
          .add(GetClinicOfferEvent(clinicId: widget.clinicInfoEntity.id!));
    }
  }

  @override
  void dispose() {
    _titleArController.dispose();
    _titleEnController.dispose();
    _detailsArController.dispose();
    _detailsEnController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  void _populateOffer(OfferEntity? offer) {
    if (_isDataLoaded || offer == null) return;
    _isDataLoaded = true;

    _existingOfferId = offer.id;
    _titleArController.text = offer.titleAr ?? '';
    _titleEnController.text = offer.titleEn ?? '';
    _detailsArController.text = offer.detailsAr ?? '';
    _detailsEnController.text = offer.detailsEn ?? '';
    _discountController.text =
        offer.discount != null ? offer.discount.toString() : '';
    _startDate = offer.startDate;
    _endDate = offer.endDate ?? offer.expiryDate;
    _isActive = offer.isActive;
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    final titleAr = _titleArController.text.trim();
    final titleEn = _titleEnController.text.trim();

    if (titleAr.isEmpty && titleEn.isEmpty) {
      AppSnackBar.show(
        context: context,
        message: AppString.offerTitleValidator,
        background: Colors.redAccent,
      );
      return;
    }

    if (_startDate != null && _endDate != null && _endDate!.isBefore(_startDate!)) {
      AppSnackBar.show(
        context: context,
        message: AppString.offerDatesValidator,
        background: Colors.redAccent,
      );
      return;
    }

    num? discount;
    if (_discountController.text.trim().isNotEmpty) {
      discount = num.tryParse(_discountController.text.trim());
      if (discount == null || discount <= 0 || discount > 100) {
        AppSnackBar.show(
          context: context,
          message: AppString.offerDiscountValidator,
          background: Colors.redAccent,
        );
        return;
      }
    }

    final offer = OfferEntity(
      id: _existingOfferId,
      clinicId: widget.clinicInfoEntity.id,
      titleAr: titleAr.isEmpty ? null : titleAr,
      titleEn: titleEn.isEmpty ? null : titleEn,
      detailsAr: _detailsArController.text.trim().isEmpty
          ? null
          : _detailsArController.text.trim(),
      detailsEn: _detailsEnController.text.trim().isEmpty
          ? null
          : _detailsEnController.text.trim(),
      discount: discount,
      startDate: _startDate,
      endDate: _endDate,
      expiryDate: _endDate,
      isActive: _isActive,
    );

    context
        .read<ClinicOfferBloc>()
        .add(SaveClinicOfferEvent(offerEntity: offer));
  }

  void _confirmDelete() {
    if (_existingOfferId == null) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppString.deleteOffer),
        content: Text(AppString.deleteOfferConfirmation),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppString.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              context
                  .read<ClinicOfferBloc>()
                  .add(DeleteClinicOfferEvent(offerId: _existingOfferId!));
            },
            child: Text(AppString.deleteOffer),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final initial = isStart
        ? (_startDate ?? now)
        : (_endDate ?? _startDate ?? now);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarSave(
        text: AppString.clinicOffer,
        onTap: _onSave,
      ),
      body: BlocConsumer<ClinicOfferBloc, ClinicOfferState>(
        listener: (context, state) {
          if (state is ClinicOfferSaveSuccess) {
            AppSnackBar.show(
              context: context,
              message: AppString.offerSavedSuccessfully,
              background: AppColors.green,
            );
            context.pop();
          } else if (state is ClinicOfferDeleteSuccess) {
            AppSnackBar.show(
              context: context,
              message: AppString.offerDeletedSuccessfully,
              background: AppColors.green,
            );
            context.pop();
          } else if (state is ClinicOfferError) {
            AppSnackBar.show(
              context: context,
              message: state.errorMessage,
              background: Colors.redAccent,
            );
          } else if (state is ClinicOfferLoaded) {
            _populateOffer(state.offer);
          }
        },
        builder: (context, state) {
          if (state is ClinicOfferLoading) {
            return const Center(child: AppLoadingWidget());
          }

          final isBusy =
              state is ClinicOfferSaving || state is ClinicOfferDeleting;

          return Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppPadding.horizontal,
                    vertical: 16.h,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatusCard(),
                        20.hBox,
                        TextFormFiledWidget(
                          controller: _titleArController,
                          label: AppString.offerTitleAr,
                        ),
                        TextFormFiledWidget(
                          controller: _titleEnController,
                          label: AppString.offerTitleEn,
                        ),
                        TextFormFiledWidget(
                          controller: _detailsArController,
                          label: AppString.offerDetailsAr,
                          maxLines: 3,
                        ),
                        TextFormFiledWidget(
                          controller: _detailsEnController,
                          label: AppString.offerDetailsEn,
                          maxLines: 3,
                        ),
                        TextFormFiledWidget(
                          controller: _discountController,
                          label: AppString.discountPercentage,
                          keyboardType: TextInputType.number,
                          suffixText: "%",
                        ),
                        20.hBox,
                        _buildDatePickers(),
                        30.hBox,
                        if (_existingOfferId != null) ...[
                          Center(
                            child: OutlinedButton.icon(
                              onPressed: isBusy ? null : _confirmDelete,
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.redAccent),
                              label: Text(
                                AppString.deleteOffer,
                                style: const TextStyle(color: Colors.redAccent),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.redAccent),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.w,
                                  vertical: 12.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                            ),
                          ),
                          20.hBox,
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              if (isBusy)
                Container(
                  color: Colors.black26,
                  child: const Center(child: AppLoadingWidget()),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusCard() {
    final isExpired = _endDate != null && _endDate!.isBefore(DateTime.now());

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: _isActive ? AppColors.primary : Colors.grey.shade300,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _isActive
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_offer_rounded,
                  color: _isActive ? AppColors.primary : Colors.grey,
                  size: 24.sp,
                ),
              ),
              12.wBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.activeOffer,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff1E293B),
                      ),
                    ),
                    4.hBox,
                    Text(
                      AppString.activeOfferSubtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xff64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _isActive,
                activeTrackColor: AppColors.primary,
                onChanged: (val) {
                  setState(() {
                    _isActive = val;
                  });
                },
              ),
            ],
          ),
          if (isExpired && _isActive) ...[
            10.hBox,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.amber.shade400),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.amber.shade800, size: 16.sp),
                  6.wBox,
                  Text(
                    AppString.offerExpired,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDatePickers() {
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Row(
      children: [
        Expanded(
          child: _buildDateTile(
            label: AppString.selectStartDate,
            date: _startDate,
            dateFormat: dateFormat,
            onTap: () => _pickDate(isStart: true),
          ),
        ),
        16.wBox,
        Expanded(
          child: _buildDateTile(
            label: AppString.selectEndDate,
            date: _endDate,
            dateFormat: dateFormat,
            onTap: () => _pickDate(isStart: false),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTile({
    required String label,
    required DateTime? date,
    required DateFormat dateFormat,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xff64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
            6.hBox,
            Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 16.sp, color: AppColors.primary),
                8.wBox,
                Expanded(
                  child: Text(
                    date != null ? dateFormat.format(date) : '-- / -- / ----',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: date != null
                          ? const Color(0xff1E293B)
                          : Colors.grey.shade400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
