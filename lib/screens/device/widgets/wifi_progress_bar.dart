import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WifiProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Color primaryColor;

  const WifiProgressBar({
    super.key,
    required this.currentStep,
    required this.primaryColor,
    this.totalSteps = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCircle(0),
          _buildLine(0),
          _buildCircle(1),
        ],
      ),
    );
  }

  Widget _buildCircle(int index) {
    final isActive = index == currentStep;
    final isDone = index < currentStep;
    return AnimatedContainer(
      duration: 400.ms,
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDone ? Colors.green : (isActive ? primaryColor : Colors.white),
        boxShadow: isActive ? [BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))] : null,
      ),
      child: Center(
        child: isDone 
          ? const Icon(Icons.check_rounded, size: 20, color: Colors.white)
          : Text('${index + 1}', style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.w900, color: isActive ? Colors.white : Colors.grey.withOpacity(0.5))),
      ),
    );
  }

  Widget _buildLine(int index) {
    final isDone = index < currentStep;
    return Expanded(
      child: Container(
        height: 3,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: isDone ? Colors.green.withOpacity(0.3) : primaryColor.withOpacity(0.1),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: isDone ? 1.0 : 0.0,
          child: Container(color: Colors.green),
        ),
      ),
    );
  }
}
