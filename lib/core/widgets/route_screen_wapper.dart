import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RootScreenWrapper extends StatelessWidget {
  final Widget child;
  const RootScreenWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: child,
    );
  }
}
