import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SafetySectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const SafetySectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: iconColor.withOpacity(0.1)),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title, 
                style: GoogleFonts.beVietnamPro(
                  fontSize: 18, 
                  fontWeight: FontWeight.w800, 
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  height: 1.4,
                ),
              ),
              Text(
                subtitle, 
                style: GoogleFonts.beVietnamPro(
                  color: Theme.of(context).textTheme.bodySmall?.color, 
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
