import 'package:flutter/material.dart';

class SlideIn extends StatelessWidget {
  final Animation<Offset> animation;
  final Widget child;

  const SlideIn({super.key, required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: animation, child: child);
  }
}
