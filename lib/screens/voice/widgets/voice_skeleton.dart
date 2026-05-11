import 'package:flutter/material.dart';
import '../../../widgets/glass_loading_base.dart';

class VoiceSkeleton extends StatelessWidget {
  const VoiceSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: 5,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            const GlassLoadingBase(width: 48, height: 48, borderRadius: 14),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  GlassLoadingBase(width: 100, height: 18, borderRadius: 6),
                  SizedBox(height: 8),
                  GlassLoadingBase(width: 150, height: 12, borderRadius: 4),
                ],
              ),
            ),
            const GlassLoadingBase(width: 32, height: 32, borderRadius: 16),
          ],
        ),
      ),
    );
  }
}
