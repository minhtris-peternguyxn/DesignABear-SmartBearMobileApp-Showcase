import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProfileAvatarSection extends StatelessWidget {
  final String serialNumber;
  final String? profileImageUrl;
  final VoidCallback? onTap;

  const ProfileAvatarSection({
    super.key, 
    required this.serialNumber,
    this.profileImageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onTap,
            child: Stack(
            alignment: Alignment.center,
            children: [
              // Multiple animated rings for a more complex glow
              ...List.generate(3, (index) => 
                Container(
                  width: 130 + (index * 20.0),
                  height: 130 + (index * 20.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF7C5CFC).withOpacity(0.15 / (index + 1)),
                      width: 2,
                    ),
                  ),
                ).animate(onPlay: (c) => c.repeat(reverse: true))
                 .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: (2000 + index * 500).ms, curve: Curves.easeInOut),
              ),

              // Bear Avatar Circle
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C5CFC), Color(0xFF9D8BFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  image: profileImageUrl != null && profileImageUrl!.isNotEmpty
                      ? DecorationImage(image: NetworkImage(profileImageUrl!), fit: BoxFit.cover)
                      : null,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C5CFC).withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: profileImageUrl != null && profileImageUrl!.isNotEmpty
                    ? null
                    : const Center(
                        child: Icon(
                          Icons.pets_rounded,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
              ),

              // Premium Verified Badge
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                  ),
                  child: const Icon(Icons.verified_rounded, color: Color(0xFF7C5CFC), size: 18),
                ).animate().scale(delay: 400.ms, curve: Curves.elasticOut),
              ),
            ],
          ),
        ),
          const SizedBox(height: 12),
          Text(
            'Nhấn để đổi ảnh',
            style: GoogleFonts.beVietnamPro(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF7C5CFC).withOpacity(0.8),
            ),
          ).animate().fadeIn(delay: 600.ms),
          const SizedBox(height: 20),
          
          // Refined Serial Number Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E293B).withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.qr_code_scanner_rounded, size: 14, color: Color(0xFF94A3B8)),
                const SizedBox(width: 8),
                Text(
                  serialNumber.toUpperCase(),
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
        ],
      ),
    );
  }
}
