import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A reusable animated background with soft aura blobs.
/// Used across V3.8 design system screens.
class AuraBackground extends StatelessWidget {
  final Color backgroundColor;
  final List<AuraBlob> blobs;
  final double blurSigma;

  const AuraBackground({
    super.key,
    this.backgroundColor = const Color(0xFFF4F7FF),
    this.blobs = const [
      AuraBlob(
        color: Color(0xFF17409A), // Navy
        size: 500,
        top: -100,
        left: -50,
        opacity: 0.08,
        moveOffset: Offset(40, 60),
        durationSeconds: 12,
      ),
      AuraBlob(
        color: Color(0xFFFF8C42), // Orange
        size: 450,
        top: 150,
        right: -150,
        opacity: 0.1,
        moveOffset: Offset(-80, 40),
        durationSeconds: 18,
      ),
      AuraBlob(
        color: Color(0xFF7C5CFC), // Purple
        size: 400,
        bottom: 50,
        left: -100,
        opacity: 0.06,
        moveOffset: Offset(60, -30),
        durationSeconds: 15,
      ),
    ],
    this.blurSigma = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: backgroundColor == const Color(0xFFF4F7FF) ? Theme.of(context).scaffoldBackgroundColor : backgroundColor),
        ...blobs.map((blob) => _buildBlob(blob)),
        Positioned.fill(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: Container(color: Colors.transparent),
          ),
        ),
      ],
    );
  }

  Widget _buildBlob(AuraBlob blob) {
    return Positioned(
      top: blob.top,
      bottom: blob.bottom,
      left: blob.left,
      right: blob.right,
      child: Container(
        width: blob.size,
        height: blob.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              blob.color.withOpacity(blob.opacity),
              blob.color.withOpacity(blob.opacity * 0.5),
              Colors.transparent,
            ],
            stops: const [0.2, 0.5, 1.0],
          ),
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true))
       .move(begin: Offset.zero, end: blob.moveOffset, duration: blob.durationSeconds.seconds, curve: Curves.easeInOutSine),
    );
  }
}

class AuraBlob {
  final Color color;
  final double size;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double opacity;
  final Offset moveOffset;
  final int durationSeconds;

  const AuraBlob({
    required this.color,
    required this.size,
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.opacity,
    required this.moveOffset,
    required this.durationSeconds,
  });
}
