import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

Future<void> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback onConfirm,
}) async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel".tr()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: Text("OK".tr()),
          ),
        ],
      );
    },
  );
}
