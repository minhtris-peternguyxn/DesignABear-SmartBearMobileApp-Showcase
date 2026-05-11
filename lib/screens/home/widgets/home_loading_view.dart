import 'package:flutter/material.dart';
import '../../../widgets/glass_loading_base.dart';

class HomeLoadingView extends StatelessWidget {
  const HomeLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const SizedBox(height: 16),
          const GlassLoadingBase(height: 180, borderRadius: 32),
          const SizedBox(height: 16),
          const GlassLoadingBase(height: 180, borderRadius: 32),
          const SizedBox(height: 16),
          const GlassLoadingBase(height: 180, borderRadius: 32),
        ]),
      ),
    );
  }
}
