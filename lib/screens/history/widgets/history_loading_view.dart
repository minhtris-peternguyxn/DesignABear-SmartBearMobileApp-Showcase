import 'package:flutter/material.dart';
import '../../../widgets/glass_loading_base.dart';

class HistoryLoadingView extends StatelessWidget {
  const HistoryLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: const [
            SizedBox(height: 16),
            GlassLoadingBase(height: 160, borderRadius: 24),
            SizedBox(height: 16),
            GlassLoadingBase(height: 160, borderRadius: 24),
            SizedBox(height: 16),
            GlassLoadingBase(height: 160, borderRadius: 24),
          ],
        ),
      ),
    );
  }
}
