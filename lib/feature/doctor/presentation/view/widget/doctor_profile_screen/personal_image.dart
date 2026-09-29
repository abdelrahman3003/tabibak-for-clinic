import 'dart:io' show File;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/manager/doctor_profile/doctor_profile_bloc.dart';

class PersonalImage extends StatefulWidget {
  const PersonalImage({super.key, this.imageUrl});
  final String? imageUrl;

  @override
  State<PersonalImage> createState() => _PersonalImageState();
}

class _PersonalImageState extends State<PersonalImage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void didUpdateWidget(covariant PersonalImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      setState(() {
        _imageFile = null;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null && mounted) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      context
          .read<DoctorProfileBloc>()
          .add(UploadImageProfileEvent(imagePath: _imageFile!.path));
    }
  }

  void _removeImage() {
    setState(() {
      _imageFile = null;
    });
    context.read<DoctorProfileBloc>().add(DeleteImageProfileEvent());
  }

  void _showImageOptions(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';
    final bool hasImage = _imageFile != null ||
        (widget.imageUrl != null && widget.imageUrl!.isNotEmpty);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  isArabic ? 'صورة الملف الشخصي' : 'Profile Photo',
                  style: Theme.of(sheetContext).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined,
                      color: AppColors.primary),
                  title: Text(
                    isArabic ? 'اختيار من المعرض' : 'Choose from Gallery',
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined,
                      color: AppColors.primary),
                  title: Text(
                    isArabic ? 'التقاط بالكاميرا' : 'Take a Photo',
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickImage(ImageSource.camera);
                  },
                ),
                if (hasImage)
                  ListTile(
                    leading:
                        const Icon(Icons.delete_outline, color: Colors.red),
                    title: Text(
                      isArabic ? 'حذف الصورة الشخصية' : 'Remove Photo',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _removeImage();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorProfileBloc, DoctorProfileState>(
      buildWhen: (previous, current) =>
          current is UploadImageProfileLoading ||
          current is UploadImageProfileSuccess ||
          current is UploadImageProfileFailed ||
          current is DeleteImageProfileLoading ||
          current is DeleteImageProfileSuccess ||
          current is DeleteImageProfileFailed,
      builder: (context, state) {
        final bool isLoading = state is UploadImageProfileLoading ||
            state is DeleteImageProfileLoading;

        return Stack(
          children: [
            GestureDetector(
              onTap: () => _showImageOptions(context),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : (widget.imageUrl != null &&
                                widget.imageUrl!.isNotEmpty)
                            ? CachedNetworkImageProvider(widget.imageUrl!)
                            : const AssetImage(
                                    "assets/images/person_blank.png")
                                as ImageProvider,
                  ),
                  if (isLoading)
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black38,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap: () => _showImageOptions(context),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.camera_alt,
                      color: Colors.white, size: 18),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
