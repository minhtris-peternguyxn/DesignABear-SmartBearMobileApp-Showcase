import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoogleLoginButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const GoogleLoginButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  State<GoogleLoginButton> createState() => _GoogleLoginButtonState();
}

class _GoogleLoginButtonState extends State<GoogleLoginButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (!widget.isLoading) setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        if (!widget.isLoading) {
          setState(() => _isPressed = false);
          widget.onPressed();
        }
      },
      onTapCancel: () {
        if (!widget.isLoading) setState(() => _isPressed = false);
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: widget.isLoading
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04), // Bóng đổ mờ thanh lịch
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: widget.isLoading
              ? const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF17409A)), // Primary blue
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Google logo (G)
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CustomPaint(painter: _GoogleLogoPainter()),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Đăng nhập với Google',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF17409A), // Primary Navy
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// Họa sĩ vẽ logo chữ G (Tái sử dụng)
class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Blue
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -pi / 6 * 1.2, pi / 3 * 2.4, true, paint);

    // Red
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -pi / 2, -pi / 6 * 3.2, true, paint);

    // Yellow
    paint.color = const Color(0xFFFBBC04);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        pi * 7 / 6, pi / 3, true, paint);

    // Green
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        pi / 2, pi * 2 / 3, true, paint);

    // White center
    paint.color = Colors.white;
    canvas.drawCircle(center, radius * 0.6, paint);

    // White right cutout (for the "G" shape)
    paint.color = Colors.white;
    canvas.drawRect(
        Rect.fromLTWH(center.dx, center.dy - radius * 0.2, radius, radius * 0.4),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
