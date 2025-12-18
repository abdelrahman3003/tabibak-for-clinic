import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/functions/pick_image.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_file_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/view/widget/doctor_profile_screen/education_image.dart';

class EducationCertificates extends StatefulWidget {
  final Function(List<XFile>) onUpdatedFiles;
  final List<DoctorFileEntity>? imageUrlList;
  const EducationCertificates({
    super.key,
    required this.onUpdatedFiles,
    required this.imageUrlList,
  });

  @override
  State<EducationCertificates> createState() => _EducationCertificatesState();
}

class _EducationCertificatesState extends State<EducationCertificates> {
  List<XFile> files = [];

  late List<DoctorFileEntity>? imageUrlLocalList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    imageUrlLocalList = (widget.imageUrlList ?? [])
        .map((e) => DoctorFileEntity(id: e.id, fileUrl: e.fileUrl))
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (files.isNotEmpty || imageUrlLocalList!.isNotEmpty)
          SizedBox(
            height: 250.h,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                      children: List.generate(
                    files.length,
                    (index) => EducationImage(
                      file: files[index],
                      onRemove: () {
                        files.removeAt(index);
                        widget.onUpdatedFiles(files);
                        setState(() {});
                      },
                    ),
                  )),
                  Column(
                      children:
                          List.generate(imageUrlLocalList!.length, (index) {
                    return EducationImage(
                      imageUrl: imageUrlLocalList![index].fileUrl,
                      onRemove: () {
                        imageUrlLocalList!.removeAt(index);
                        setState(() {});
                      },
                    );
                  })),
                ],
              ),
            ),
          ),
        10.hBox,
        InkWell(
          onTap: () async {
            final file = await pickImage();

            if (file != null) {
              files.add(file);
              widget.onUpdatedFiles(files);
              setState(() {});
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration:
                BoxDecoration(border: Border.all(color: AppColors.primary)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
                5.wBox,
                Text(
                  "Add Certificate",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
