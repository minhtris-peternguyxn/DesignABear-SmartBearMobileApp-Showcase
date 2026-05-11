import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileInputCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget child;
  final EdgeInsets? padding;
  final Color? highlightColor;
  final bool flat;

  const ProfileInputCard({
    super.key,
    required this.icon,
    required this.label,
    required this.child,
    this.padding,
    this.highlightColor,
    this.flat = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final shadowColor = isDark ? Colors.black : const Color(0xFF1A1A2E);

    if (flat) {
      return Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: _buildContent(context),
      );
    }

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: highlightColor ?? cardColor.withOpacity(isDark ? 0.3 : 0.4),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: cardColor.withOpacity(isDark ? 0.1 : 0.4)),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: const Color(0xFF7C5CFC).withOpacity(0.7)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label.toUpperCase(), 
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 10, 
                  fontWeight: FontWeight.w800,
                  color: Colors.grey[500], 
                  letterSpacing: 1.2,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Theme.of(context).cardTheme.color, // For dropdowns
          ),
          child: child,
        ),
      ],
    );
  }
}
