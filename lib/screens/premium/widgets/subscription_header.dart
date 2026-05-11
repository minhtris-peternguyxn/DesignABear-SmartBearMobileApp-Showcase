import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionHeader extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onRefresh;

  const SubscriptionHeader({
    super.key,
    required this.onBack,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textPrimary = Theme.of(context).textTheme.bodyLarge?.color ?? const Color(0xFF1A1A2E);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Glass Back Button
          _buildGlassButton(
            context,
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: onBack,
            color: textPrimary,
          ),
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'KHO QUÀ',
                  style: GoogleFonts.beVietnamPro(
                    color: colorScheme.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'SmartBear Premium',
                  style: GoogleFonts.beVietnamPro(
                    color: textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          
          _buildGlassButton(
            context,
            icon: Icons.refresh_rounded,
            onTap: onRefresh,
            color: textPrimary.withOpacity(0.4),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05)),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
        ),
      ),
    );
  }
}
