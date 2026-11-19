import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../design_system/design_system.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    super.key,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ClipRRect(
      borderRadius: borderRadius == 0 ? BorderRadius.zero : AppRadius.mdRadius,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,

        // placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: theme.colorScheme.surfaceContainerHighest,
          alignment: Alignment.center,
          child: Icon(
            Icons.broken_image_outlined,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
