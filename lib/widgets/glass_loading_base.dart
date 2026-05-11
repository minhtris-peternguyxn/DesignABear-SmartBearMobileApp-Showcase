import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GlassLoadingBase extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const GlassLoadingBase({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0),
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0),
              ],
              stops: const [0.3, 0.5, 0.7],
            ),
          ),
        ).animate(onPlay: (controller) => controller.repeat())
         .shimmer(
           duration: 1500.ms,
           color: Colors.white.withOpacity(0.4),
         ),
      ),
    );
  }
}
