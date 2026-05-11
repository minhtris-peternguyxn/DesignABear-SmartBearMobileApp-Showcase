import 'package:flutter/material.dart';
import '../../../widgets/glass_loading_base.dart';

class AlarmSkeleton extends StatelessWidget {
  const AlarmSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: 4,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            const GlassLoadingBase(width: 60, height: 40, borderRadius: 12),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  GlassLoadingBase(width: 120, height: 20, borderRadius: 8),
                  SizedBox(height: 8),
                  GlassLoadingBase(width: 80, height: 14, borderRadius: 6),
                ],
              ),
            ),
            const GlassLoadingBase(width: 40, height: 20, borderRadius: 20),
          ],
        ),
      ),
    );
  }
}
