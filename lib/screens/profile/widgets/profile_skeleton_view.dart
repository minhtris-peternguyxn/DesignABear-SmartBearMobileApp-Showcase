import 'package:flutter/material.dart';
import '../../../widgets/glass_loading_base.dart';

class ProfileSkeletonView extends StatelessWidget {
  const ProfileSkeletonView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: const [
            SizedBox(height: 100),
            // Avatar Skeleton
            Center(child: GlassLoadingBase(width: 120, height: 120, borderRadius: 60)),
            SizedBox(height: 32),
            
            // Name/Basic Info Skeletons
            GlassLoadingBase(height: 80, borderRadius: 20),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: GlassLoadingBase(height: 80, borderRadius: 20)),
                SizedBox(width: 12),
                Expanded(child: GlassLoadingBase(height: 80, borderRadius: 20)),
              ],
            ),
            SizedBox(height: 48),

            // AI Personality Skeleton
            GlassLoadingBase(height: 80, borderRadius: 20),
            SizedBox(height: 12),
            GlassLoadingBase(height: 120, borderRadius: 20),
            
            SizedBox(height: 48),
            // Sliders Skeleton
            GlassLoadingBase(height: 80, borderRadius: 20),
            SizedBox(height: 12),
            GlassLoadingBase(height: 80, borderRadius: 20),
          ],
        ),
      ),
    );
  }
}
