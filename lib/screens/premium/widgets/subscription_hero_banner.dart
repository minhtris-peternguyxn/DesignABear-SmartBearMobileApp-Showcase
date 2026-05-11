import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../data/models/response/payment_response.dart';

class SubscriptionHeroBanner extends StatelessWidget {
  final SubscriptionStatusModel? status;
  final Animation<double> shimmer;

  const SubscriptionHeroBanner({
    super.key,
    required this.status,
    required this.shimmer,
  });

  String _formatNum(dynamic n) {
    final v = (n is int) ? n : (int.tryParse('$n') ?? 0);
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}tr';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(v % 1000 == 0 ? 0 : 1)}k';
    return '$v';
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF17409A);
    const accentWarm = Color(0xFFFF8C42);
    const textPrimary = Color(0xFF1A1A2E);
    
    final isPro = status?.isPro ?? false;
    final candies = status?.smartCandies ?? 0;
    final accentColor = isPro ? primaryColor : const Color(0xFF6366F1);

    return AnimatedBuilder(
      animation: shimmer,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.08),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: accentColor.withOpacity(0.2 + shimmer.value * 0.1),
                    width: 1.5,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      accentColor.withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    // Premium Badge / Icon
                    _buildStatusIcon(isPro, accentColor),
                    const SizedBox(width: 20),
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (status?.planName ?? (isPro ? 'SMARTBEAR PRO' : 'GÓI CƠ BẢN')).toUpperCase(),
                            style: GoogleFonts.beVietnamPro(
                              color: accentColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: accentWarm.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.stars_rounded, color: accentWarm, size: 14),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${_formatNum(candies)} kẹo tích lũy',
                                      style: GoogleFonts.beVietnamPro(
                                        color: textPrimary.withOpacity(0.8),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (isPro && status?.proExpiresAt != null) ...[
                            const SizedBox(height: 10),
                            _buildExpiryInfo(status!.proExpiresAt!),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, curve: Curves.easeOut);
      },
    );
  }

  Widget _buildStatusIcon(bool isPro, Color color) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Center(
        child: isPro 
            ? Icon(Icons.workspace_premium_rounded, color: color, size: 32)
            : Icon(Icons.person_pin_circle_rounded, color: color, size: 30),
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true))
     .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 2.seconds);
  }

  Widget _buildExpiryInfo(DateTime expiry) {
    return Row(
      children: [
        Icon(Icons.calendar_today_rounded, color: const Color(0xFF1A1A2E).withOpacity(0.3), size: 12),
        const SizedBox(width: 6),
        Text(
          'Hết hạn: ${expiry.day}/${expiry.month}/${expiry.year}',
          style: GoogleFonts.beVietnamPro(
            color: const Color(0xFF6B7280),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
