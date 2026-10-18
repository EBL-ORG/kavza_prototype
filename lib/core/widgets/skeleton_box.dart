import 'package:flutter/material.dart';

import '../theme/kafza_theme.dart';

/// Loading placeholder block on muted. Static on purpose: no shimmer to tune or to disable
/// for reduced motion.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({super.key, this.width, required this.height, this.radius = KafzaRadius.input});

  final double? width;
  final double height, radius;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(color: context.kafza.muted, borderRadius: BorderRadius.circular(radius)),
        ),
      );
}
