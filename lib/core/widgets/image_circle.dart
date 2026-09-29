import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageCircle extends StatelessWidget {
  const ImageCircle({super.key, this.imageUrl, this.radius});
  final String? imageUrl;
  final double? radius;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius ?? 26,
      backgroundColor: Colors.grey.shade100,
      backgroundImage: (imageUrl != null && imageUrl!.isNotEmpty)
          ? CachedNetworkImageProvider(imageUrl!)
          : const AssetImage("assets/images/person_blank.png") as ImageProvider,
    );
  }
}
