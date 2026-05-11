import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionCandyPackage extends StatelessWidget {
  final int id;
  final String label;
  final String name;
  final String price;
  final bool isPopular;
  final bool buyLoading;
  final VoidCallback onBuyTap;

  const SubscriptionCandyPackage({
    super.key,
    required this.id,
    required this.label,
    required this.name,
    required this.price,
    required this.isPopular,
    required this.buyLoading,
    required this.onBuyTap,
  });

  @override
  Widget build(BuildContext context) {
    const accentWarm = Color(0xFFFF8C42);
    const textPrimary = Color(0xFF1A1A2E);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isPopular ? accentWarm.withOpacity(0.12) : textPrimary.withOpacity(0.03),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onBuyTap,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isPopular ? accentWarm.withOpacity(0.3) : Colors.black.withOpacity(0.05),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Candy Icon Box
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: accentWarm.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Icon(Icons.stars_rounded, color: accentWarm, size: 24),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  name,
                                  style: GoogleFonts.beVietnamPro(
                                    color: textPrimary,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isPopular) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: accentWarm,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'GIÁ TRỊ',
                                    style: GoogleFonts.beVietnamPro(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            label,
                            style: GoogleFonts.beVietnamPro(
                              color: const Color(0xFF6B7280),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Price Tag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: accentWarm.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: buyLoading
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: accentWarm, strokeWidth: 2))
                        : Text(
                            price,
                            style: GoogleFonts.beVietnamPro(
                              color: accentWarm,
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                            ),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
