import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SubscriptionSkeleton extends StatelessWidget {
  const SubscriptionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Skeleton
          _buildGlassBox(height: 180, width: double.infinity, radius: 32),
          const SizedBox(height: 40),
          
          // Section Label
          _buildGlassBox(height: 12, width: 120, radius: 4),
          const SizedBox(height: 16),
          
          // Plan Cards Skeletons
          _buildGlassBox(height: 140, width: double.infinity, radius: 28),
          const SizedBox(height: 16),
          _buildGlassBox(height: 140, width: double.infinity, radius: 28),
          const SizedBox(height: 16),
          _buildGlassBox(height: 140, width: double.infinity, radius: 28),
          
          const SizedBox(height: 40),
          // Candy Section Label
          _buildGlassBox(height: 12, width: 150, radius: 4),
          const SizedBox(height: 16),
          
          // Candy Package Skeletons
          _buildGlassBox(height: 80, width: double.infinity, radius: 24),
          const SizedBox(height: 12),
          _buildGlassBox(height: 80, width: double.infinity, radius: 24),
        ],
      ),
    );
  }

  Widget _buildGlassBox({required double height, required double width, required double radius}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
    ).animate(onPlay: (controller) => controller.repeat())
     .shimmer(duration: 1500.ms, color: Colors.white.withOpacity(0.6));
  }
}
