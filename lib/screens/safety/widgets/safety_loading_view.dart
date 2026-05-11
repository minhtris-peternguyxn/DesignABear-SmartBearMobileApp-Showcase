import 'package:flutter/material.dart';
import '../../../widgets/glass_loading_base.dart';

class SafetyLoadingView extends StatelessWidget {
  const SafetyLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Header Skeleton
            Row(
              children: [
                const GlassLoadingBase(width: 44, height: 44, borderRadius: 22),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    GlassLoadingBase(width: 80, height: 12),
                    SizedBox(height: 8),
                    GlassLoadingBase(width: 150, height: 32),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Section Header 1
            Row(
              children: [
                const GlassLoadingBase(width: 40, height: 40, borderRadius: 12),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    GlassLoadingBase(width: 120, height: 16),
                    SizedBox(height: 6),
                    GlassLoadingBase(width: 200, height: 12),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Word Input Skeleton
            const GlassLoadingBase(height: 110, borderRadius: 28),
            const SizedBox(height: 16),

            // Word List Skeletons
            const GlassLoadingBase(height: 60, borderRadius: 18),
            const SizedBox(height: 10),
            const GlassLoadingBase(height: 60, borderRadius: 18),
            const SizedBox(height: 48),

            // Section Header 2
            Row(
              children: [
                const GlassLoadingBase(width: 40, height: 40, borderRadius: 12),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    GlassLoadingBase(width: 140, height: 16),
                    SizedBox(height: 6),
                    GlassLoadingBase(width: 180, height: 12),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Device Card Skeletons
            const GlassLoadingBase(height: 100, borderRadius: 32),
            const SizedBox(height: 24),
            const GlassLoadingBase(height: 100, borderRadius: 32),
            
            const SizedBox(height: 40),
            // Info Card Skeleton
            const GlassLoadingBase(height: 180, borderRadius: 32),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
