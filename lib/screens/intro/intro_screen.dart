import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/aura_background.dart';

class IntroScreen extends StatelessWidget {
  final VoidCallback onFinished;

  const IntroScreen({super.key, required this.onFinished});

  @override
  Widget build(BuildContext context) {
    // Tự động kết thúc sau 2.5s (bao gồm cả thời gian chờ và animate)
    Future.delayed(const Duration(milliseconds: 2500), () {
      onFinished();
    });

    return Scaffold(
      body: Stack(
        children: [
          const AuraBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Container với hiệu ứng Premium
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF17409A).withOpacity(0.2),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
                .animate()
                .scale(duration: 800.ms, curve: Curves.elasticOut)
                .shimmer(delay: 1000.ms, duration: 1500.ms, color: Colors.white54),

                const SizedBox(height: 40),

                // Text App Name
                Text(
                  'SMARTBEAR',
                  style: GoogleFonts.fredoka(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: const Color(0xFF1A1A2E),
                  ),
                )
                .animate()
                .fadeIn(delay: 400.ms, duration: 600.ms)
                .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 8),

                // Tagline
                Text(
                  'AI - Companion for Future',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 4,
                    color: const Color(0xFF1A1A2E).withOpacity(0.4),
                  ),
                )
                .animate()
                .fadeIn(delay: 800.ms, duration: 600.ms),
              ],
            ),
          ),
          
          // Thanh trạng thái loading tinh tế ở dưới cùng
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF17409A).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF17409A)),
                  ),
                ),
              ).animate().fadeIn(delay: 1200.ms),
            ),
          ),
        ],
      ),
    );
  }
}
