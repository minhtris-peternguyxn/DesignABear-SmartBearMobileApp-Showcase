import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WifiStepCard extends StatelessWidget {
  final int step;
  final int currentStep;
  final IconData icon;
  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback onAction;
  final VoidCallback? onBack;
  final Widget? child;
  final Color primaryColor;
  final Color textPrimary;

  const WifiStepCard({
    super.key,
    required this.step,
    required this.currentStep,
    required this.icon,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onAction,
    this.onBack,
    this.child,
    required this.primaryColor,
    required this.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = currentStep == step;
    final isDone = currentStep > step;
    
    if (isDone && child == null) return const SizedBox.shrink();

    return AnimatedOpacity(
      duration: 500.ms,
      opacity: isActive || isDone ? 1.0 : 0.4,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.9) : Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isActive ? primaryColor.withOpacity(0.3) : Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: isActive ? [
            BoxShadow(color: primaryColor.withOpacity(0.1), blurRadius: 30, offset: const Offset(0, 10)),
          ] : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isActive ? primaryColor.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: isActive ? primaryColor : Colors.grey.withOpacity(0.5), size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.w900, 
                      fontSize: 17, 
                      color: isActive ? textPrimary : textPrimary.withOpacity(0.4),
                    ),
                  ),
                ),
                if (isDone) const Icon(Icons.check_circle_rounded, color: Colors.green, size: 24),
              ],
            ),
            if (isActive) ...[
              const SizedBox(height: 16),
              Text(
                description,
                style: GoogleFonts.beVietnamPro(fontSize: 14, color: textPrimary.withOpacity(0.6), height: 1.6),
              ),
              if (child != null) ...[const SizedBox(height: 24), child!],
              const SizedBox(height: 24),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: onAction,
                      child: Text(actionLabel, style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  if (onBack != null) ...[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: onBack,
                      child: Text(
                        'Quay lại bước trước',
                        style: GoogleFonts.beVietnamPro(color: textPrimary.withOpacity(0.4), fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ],
              ),
            ]
          ],
        ),
      ),
    ).animate(target: isActive || isDone ? 1 : 0).fadeIn(duration: 400.ms);
  }
}
