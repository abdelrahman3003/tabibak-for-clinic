import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';

class EducationImage extends StatelessWidget {
  const EducationImage({
    super.key,
    this.file,
    this.imageUrl,
  });

  final XFile? file;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              file != null
                  ? Image.file(
                      File(file!.path),
                      width: 150.w,
                      height: 80.h,
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      imageUrl: imageUrl!,
                      width: 150.w,
                      height: 80.h,
                      fit: BoxFit.cover,
                    ),
              10.hBox,
              if (file != null)
                SizedBox(
                  width: 150.w,
                  child: Text(
                    file!.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
