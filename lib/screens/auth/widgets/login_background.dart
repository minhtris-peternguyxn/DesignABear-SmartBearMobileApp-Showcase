import 'dart:ui';
import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox.expand(
      child: Stack(
        children: [
          // ── Quầng sáng 1: Primary Navy loang lỗ ──
          _buildGlowBlob(
            top: -size.height * 0.1,
            left: -size.width * 0.2,
            size: size.width * 1.2,
            color: const Color(0xFF17409A).withValues(alpha: 0.08),
          ),

          // ── Quầng sáng 2: Xanh Mint phá cách ──
          _buildGlowBlob(
            top: size.height * 0.2,
            right: -size.width * 0.3,
            size: size.width * 0.8,
            color: const Color(0xFF4ECDC4).withValues(alpha: 0.05),
          ),

          // ── Quầng sáng 3: Cam ấm tinh tế ──
          _buildGlowBlob(
            bottom: size.height * 0.1,
            left: -size.width * 0.3,
            size: size.width * 0.9,
            color: const Color(0xFFFF8C42).withValues(alpha: 0.06),
          ),

          // ── Lớp Filter làm mờ cực mạnh để tạo hiệu ứng ánh sáng tan chảy ──
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: Container(color: Colors.transparent),
            ),
          ),
          
          // ── Các vòng tròn mảnh trang trí (Rings) để không bị quá trống ──
          Positioned(
            top: size.height * 0.15,
            left: size.width * 0.1,
            child: _buildRing(size.width * 0.4, const Color(0xFF17409A).withValues(alpha: 0.05)),
          ),
          Positioned(
            bottom: size.height * 0.2,
            right: size.width * 0.05,
            child: _buildRing(size.width * 0.2, const Color(0xFF4ECDC4).withValues(alpha: 0.08)),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowBlob({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required Color color,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color,
              color.withValues(alpha: 0.3),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRing(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.2),
      ),
    );
  }
}
