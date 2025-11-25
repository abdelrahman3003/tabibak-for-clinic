import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';

class DocumentUploadField extends StatefulWidget {
  final String title;
  final void Function(File?)? onFileSelected;
  final bool isRegistered;
  const DocumentUploadField({
    super.key,
    required this.title,
    this.onFileSelected,
    this.isRegistered = false,
  });

  @override
  State<DocumentUploadField> createState() => _DocumentUploadFieldState();
}

class _DocumentUploadFieldState extends State<DocumentUploadField> {
  File? _selectedFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickFile() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedFile = File(picked.path);
      });
      widget.onFileSelected?.call(_selectedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleMedium!,
        ),
        8.hBox,
        InkWell(
          onTap: _pickFile,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: widget.isRegistered && _selectedFile == null
                        ? AppColors.red
                        : Colors.grey.shade400),
                color: Colors.grey.shade100),
            child: Row(
              children: [
                const Icon(Icons.upload_file_outlined),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedFile == null
                        ? "Upload Image / File"
                        : _selectedFile!.path.split('/').last,
                    style: TextStyle(
                      color:
                          _selectedFile == null ? Colors.grey : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
