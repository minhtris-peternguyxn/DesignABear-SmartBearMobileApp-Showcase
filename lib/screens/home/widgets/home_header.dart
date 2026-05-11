import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeHeader extends StatelessWidget {
  final String displayName;
  final bool isPro;
  final VoidCallback onSettingsTap;

  const HomeHeader({
    super.key,
    required this.displayName,
    required this.isPro,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 40, 28, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SMARTBEAR',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: colorScheme.primary.withOpacity(0.4),
                        letterSpacing: 2.0,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Chào,',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.4),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            displayName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).textTheme.headlineLarge?.color,
                              letterSpacing: -0.5,
                              height: 1.2,
                            ),
                          ),
                        ),
                        if (isPro) ...[
                          const SizedBox(width: 12),
                          _buildMinimalistProBadge(),
                        ],
                      ],
                    ),
                  ],
                ).animate().fade(duration: 800.ms).slideY(begin: 0.05),
              ),
              _buildModernAction(context, Icons.settings_rounded, onSettingsTap),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMinimalistProBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF17409A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'PRO',
        style: GoogleFonts.fredoka(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildModernAction(BuildContext context, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Icon(icon, size: 24, color: Theme.of(context).textTheme.bodyLarge?.color),
      ),
    );
  }
}
