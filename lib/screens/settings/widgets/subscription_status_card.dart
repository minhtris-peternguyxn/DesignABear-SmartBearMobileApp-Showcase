import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SubscriptionStatusCard extends StatelessWidget {
  final bool isPro;
  final String? planName;
  final VoidCallback onTap;

  const SubscriptionStatusCard({
    super.key,
    required this.isPro,
    this.planName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isPro ? const Color(0xFF1A1A2E) : Theme.of(context).cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: isPro ? const Color(0xFFFFD700).withOpacity(0.5) : Colors.white.withOpacity(0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isPro ? const Color(0xFFFFD700) : Theme.of(context).shadowColor).withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(32),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TRẠNG THÁI TÀI KHOẢN',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: isPro ? Colors.grey[400] : Colors.grey[500],
                        letterSpacing: 1.5,
                      ),
                    ),
                    if (isPro)
                      const Icon(Icons.stars_rounded, color: Color(0xFFFFD700), size: 24)
                    else
                      const Icon(Icons.info_outline_rounded, color: Colors.grey, size: 20),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  planName ?? (isPro ? 'Thành viên Premium' : 'Thành viên Cơ bản'),
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: isPro ? Colors.white : Theme.of(context).textTheme.headlineSmall?.color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isPro 
                    ? 'Bạn đang tận hưởng toàn bộ tính năng cao cấp của Lucky.'
                    : 'Nâng cấp ngay để mở khóa giọng nói AI chất lượng cao và không giới hạn.',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isPro ? Colors.white.withOpacity(0.7) : Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isPro ? const Color(0xFFFFD700) : const Color(0xFF7C5CFC),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    isPro ? 'QUẢN LÝ GÓI' : 'NÂNG CẤP NGAY',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: isPro ? const Color(0xFF1A1A2E) : Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }
}
