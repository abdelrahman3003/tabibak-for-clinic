import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';

class Dialogs {
  static successDialog(BuildContext context, String title, subtitle) {
    //show dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: AppColors.green,
                size: 90.r,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              AppButton(
                title: "Close",
                color: AppColors.green,
                padding: const EdgeInsets.symmetric(vertical: 10),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  static void noOffersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.thumb_up_alt_outlined,
                size: 80.r,
                color: AppColors.primary,
              ),
              const SizedBox(height: 16),
              Text(
                "لا يوجد عروض حاليا",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              AppButton(
                title: "حسناً",
                color: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 10),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

// Bottom Sheet
  static void bottomSheet(BuildContext context, {required String title}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_outlined,
                  size: 80.r, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              AppButton(
                title: "Ok",
                color: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 10),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  // error dialog
  static errorDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                padding: const EdgeInsets.all(16),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "UnKnwon error",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const AppButton(
                title: "Clsoe",
                color: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 10),
              ),
            ],
          ),
        );
      },
    );
  }

  //alert dialog
  static alertDialog(
      {required BuildContext context,
      required String title,
      required String subtitle,
      required String confirmString,
      required Color? color,
      required bool isLoading,
      required void Function()? onPressed}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(title, style: Theme.of(context).textTheme.titleLarge),
          content: Text(title, style: Theme.of(context).textTheme.titleMedium),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: onPressed,
              child: SizedBox(
                height: 25.h,
                width: 25.w,
                child: FittedBox(
                    child: isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(5),
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                            ),
                          )
                        : Text(confirmString)),
              ),
            ),
          ],
        );
      },
    );
  }
}
