import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PlanData {
  final IconData icon;
  final String name, price, sub;
  final Color color;
  final String? badge;
  final bool isCurrent, canBuy;
  final List<String> features, locked;
  final int originalAmountOverride;

  const PlanData({
    required this.icon,
    required this.name,
    required this.price,
    required this.sub,
    required this.color,
    required this.badge,
    required this.isCurrent,
    required this.canBuy,
    required this.features,
    required this.locked,
    required this.originalAmountOverride,
  });
}

class PlanCard extends StatelessWidget {
  final PlanData p;
  final bool buyLoading;
  final VoidCallback onBuyTap;

  const PlanCard({
    super.key,
    required this.p,
    required this.buyLoading,
    required this.onBuyTap,
  });

  @override
  Widget build(BuildContext context) {
    final isHighlighted = p.badge == 'PHỔ BIẾN' || p.isCurrent;
    final primaryColor = const Color(0xFF17409A);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: isHighlighted ? p.color.withOpacity(0.12) : const Color(0xFF1A1A2E).withOpacity(0.04),
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
                color: isHighlighted ? p.color.withOpacity(0.3) : Colors.black.withOpacity(0.05),
                width: isHighlighted ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: p.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(p.icon, color: p.color, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          p.name,
                          style: GoogleFonts.beVietnamPro(
                            color: const Color(0xFF1A1A2E),
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    if (p.badge != null)
                      _buildBadge(p.badge!, p.color, p.isCurrent),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Price
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: p.price,
                        style: GoogleFonts.beVietnamPro(
                          color: const Color(0xFF1A1A2E),
                          fontWeight: FontWeight.w900,
                          fontSize: 28,
                        ),
                      ),
                      TextSpan(
                        text: p.sub,
                        style: GoogleFonts.beVietnamPro(
                          color: const Color(0xFF6B7280),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                const Divider(color: Color(0xFFE5E7EB), thickness: 1),
                const SizedBox(height: 20),
                
                // Features List
                ...p.features.map((f) => _buildFeatureItem(f, p.color, true)),
                ...p.locked.map((f) => _buildFeatureItem(f, const Color(0xFF9CA3AF), false)),
                
                const SizedBox(height: 28),
                
                // Action Button
                if (p.canBuy)
                  _buildBuyButton()
                else if (p.isCurrent)
                  _buildStatusBadge('ĐANG SỬ DỤNG', p.color),
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color, bool isCurrent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isCurrent ? color.withOpacity(0.1) : color,
        borderRadius: BorderRadius.circular(10),
        border: isCurrent ? Border.all(color: color.withOpacity(0.4)) : null,
      ),
      child: Text(
        text,
        style: GoogleFonts.beVietnamPro(
          color: isCurrent ? color : Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text, Color color, bool isActive) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isActive ? color.withOpacity(0.1) : const Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isActive ? Icons.check_rounded : Icons.lock_rounded,
              color: isActive ? color : const Color(0xFF9CA3AF),
              size: 10,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.beVietnamPro(
                color: isActive ? const Color(0xFF1A1A2E).withOpacity(0.8) : const Color(0xFF9CA3AF),
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: buyLoading ? null : onBuyTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: p.color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 4,
          shadowColor: p.color.withOpacity(0.3),
        ),
        child: buyLoading
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.bolt_rounded, size: 20),
                const SizedBox(width: 8),
                Text(
                  'NÂNG CẤP NGAY',
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.beVietnamPro(
            color: color,
            fontWeight: FontWeight.w900,
            fontSize: 14,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
