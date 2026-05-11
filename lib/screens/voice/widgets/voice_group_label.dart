import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VoiceGroupLabel extends StatelessWidget {
  final String title;
  final bool isPremium;

  const VoiceGroupLabel({
    super.key,
    required this.title,
    this.isPremium = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 16),
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: GoogleFonts.beVietnamPro(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Colors.grey[400],
              letterSpacing: 1.2,
            ),
          ),
          if (isPremium) ...[
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'PREMIUM',
                style: GoogleFonts.beVietnamPro(
                  color: Colors.amber[700],
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
