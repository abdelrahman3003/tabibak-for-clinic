import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title = '',
    this.isShowBack = true,
    this.backgroundColor = Colors.white,
    this.shadow = Colors.transparent,
    this.titleStyle,
    this.iconColor,
    this.iconLasted,
    this.height,
    this.actions,
    this.onLeadingPressed,
    this.iconButtonBgColor,
  });

  final dynamic title;
  final bool isShowBack;
  final Color? backgroundColor, iconButtonBgColor;
  final TextStyle? titleStyle;
  final Color? iconColor;
  final Color? shadow;
  final Widget? iconLasted;
  final List<Widget>? actions;
  final double? height;
  final Future<void> Function()? onLeadingPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: height,
      automaticallyImplyLeading: isShowBack,
      elevation: 1,
      scrolledUnderElevation: 1,
      shadowColor: shadow,
      leading: isShowBack == false ? null : _backButton(context),
      centerTitle: true,
      title: (title is String)
          ? Text(title,
              style: titleStyle ?? Theme.of(context).textTheme.titleLarge)
          : title,
      actions: actions ??
          [
            iconLasted ?? const SizedBox(),
          ],
    );
  }

  IconButton _backButton(BuildContext context) {
    return IconButton(
      onPressed: () async {
        if (onLeadingPressed != null) {
          await onLeadingPressed!();
        } else {
          Navigator.pop(context);
        }
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
      ),
      icon: Icon(
        Icons.arrow_back_ios,
        size: 20.5.h,
      ),
    );
  }

  @override
  Size get preferredSize =>
      height == null ? AppBar().preferredSize : Size.fromHeight(height ?? 0);
}
