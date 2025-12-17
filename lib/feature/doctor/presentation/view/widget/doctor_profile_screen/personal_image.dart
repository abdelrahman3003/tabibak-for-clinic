import 'dart:io' show File;

import 'package:cached_network_image/cached_network_image.dart';
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

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      context
          .read<DoctorProfileBloc>()
          .add(UploadImageProfileEvent(imagePath: _imageFile!.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<DoctorProfileBloc, DoctorProfileState>(
          buildWhen: (previous, current) =>
              current is UploadImageProfileLoading ||
              current is UploadImageProfileSuccess,
          builder: (context, state) {
            final bool isLoading = state is UploadImageProfileLoading;

            return Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
                          ? CachedNetworkImageProvider(widget.imageUrl!)
                          : const AssetImage("assets/images/person_blank.png")
                              as ImageProvider,
                ),
                if (isLoading)
                  const Positioned.fill(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          },
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: _pickImage,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}
