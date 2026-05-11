import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ConnectTutorialStage extends StatelessWidget {
  final int step;
  final int totalSteps;
  final IconData icon;
  final String title;
  final String body;
  final Color color;
  final Color textPrimary;

  const ConnectTutorialStage({
    super.key,
    required this.step,
    required this.totalSteps,
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
    required this.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.2), blurRadius: 40, spreadRadius: 5),
            ],
          ),
          child: Icon(icon, size: 64, color: color),
        ).animate(key: ValueKey('icon_$step')).scale(duration: 500.ms, curve: Curves.elasticOut),

        const SizedBox(height: 48),

        Text(
          title,
          style: GoogleFonts.beVietnamPro(
            color: textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
          textAlign: TextAlign.center,
        ).animate(key: ValueKey('title_$step')).fade().slideY(begin: 0.1),

        const SizedBox(height: 16),

        Text(
          body,
          style: GoogleFonts.beVietnamPro(
            color: textPrimary.withOpacity(0.6),
            fontSize: 15,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ).animate(key: ValueKey('body_$step')).fade(delay: 100.ms),
      ],
    );
  }
}
