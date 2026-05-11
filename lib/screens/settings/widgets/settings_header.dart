import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsHeader extends StatelessWidget {
  final VoidCallback onBack;
  final String? title;
  final String? subtitle;

  const SettingsHeader({
    super.key, 
    required this.onBack,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5)),
                ],
              ),
              child: Icon(Icons.arrow_back_rounded, size: 22, color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle ?? 'HỆ THỐNG',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).primaryColor.withOpacity(0.4),
                    letterSpacing: 2.0,
                    height: 1.4,
                  ),
                ),
                Text(
                  title ?? 'Cài đặt',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).textTheme.headlineLarge?.color,
                    letterSpacing: -0.5,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
