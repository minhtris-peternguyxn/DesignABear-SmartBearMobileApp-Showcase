import 'package:flutter/material.dart';
import '../../../widgets/glass_loading_base.dart';

class SettingsLoadingView extends StatelessWidget {
  const SettingsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: const [
            SizedBox(height: 100),
            GlassLoadingBase(height: 110, borderRadius: 30),
            SizedBox(height: 48),
            GlassLoadingBase(height: 80, borderRadius: 20),
            SizedBox(height: 12),
            GlassLoadingBase(height: 80, borderRadius: 20),
            SizedBox(height: 12),
            GlassLoadingBase(height: 80, borderRadius: 20),
          ],
        ),
      ),
    );
  }
}
