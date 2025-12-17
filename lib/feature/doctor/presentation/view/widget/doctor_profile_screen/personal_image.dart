import 'dart:io' show File;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey[300],
          backgroundImage: _imageFile != null
              ? FileImage(_imageFile!)
              : (widget.imageUrl != null
                  ? CachedNetworkImageProvider(widget.imageUrl!)
                  : const AssetImage("assets/images/person_blank.png")
                      as ImageProvider),
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
