import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WifiSuccessView extends StatelessWidget {
  final Map<String, dynamic> pairedDevice;
  final VoidCallback onFinish;
  final Color primaryColor;
  final Color textPrimary;

  const WifiSuccessView({
    super.key,
    required this.pairedDevice,
    required this.onFinish,
    required this.primaryColor,
    required this.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withOpacity(0.1),
                ),
              ).animate(onPlay: (c) => c.repeat()).scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: 2.seconds).fade(begin: 1, end: 0),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.2), blurRadius: 40)],
                ),
                child: const Icon(Icons.stars_rounded, size: 70, color: Colors.green),
              ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
            ],
          ),
          const SizedBox(height: 48),
          Text(
            'Kết nối thành công!',
            style: GoogleFonts.beVietnamPro(fontSize: 28, fontWeight: FontWeight.w900, color: textPrimary),
          ).animate().fade().slideY(begin: 0.3),
          const SizedBox(height: 12),
          Text(
            'Bạn và ${pairedDevice['deviceNickname'] ?? 'Gấu mới'} hiện đã là bạn tốt!',
            textAlign: TextAlign.center,
            style: GoogleFonts.beVietnamPro(fontSize: 16, color: textPrimary.withOpacity(0.6)),
          ).animate().fade(delay: 200.ms),
          const SizedBox(height: 64),
          SizedBox(
            width: 220,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 8,
                shadowColor: primaryColor.withOpacity(0.4),
              ),
              onPressed: onFinish,
              child: Text('BẮT ĐẦU TRÒ CHUYỆN', style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w900, letterSpacing: 1)),
            ),
          ).animate().scale(delay: 400.ms).fade(),
        ],
      ),
    );
  }
}
