import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'google_login_button.dart';

/// Phần đăng nhập bên dưới — KHÔNG dùng Card
/// Thiết kế full-width không viền, inline style phá cách
class LoginAuthSection extends StatelessWidget {
  final bool isLoading;
  final bool hasError;
  final String errorMessage;
  final VoidCallback onGoogleLogin;

  const LoginAuthSection({
    super.key,
    required this.isLoading,
    required this.hasError,
    required this.errorMessage,
    required this.onGoogleLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Đường phân cách trang trí — "hay hơn Card"
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFFE5E7EB), // border color
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Bắt đầu nào',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF9CA3AF), // textMuted
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFFE5E7EB),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),

        // Error message (nếu có)
        if (hasError) ...[
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: Color(0xFFFF6B9D), // accentPink
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  errorMessage,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFFFF6B9D),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],

        // Nút đăng nhập Google — full width
        GoogleLoginButton(
          isLoading: isLoading,
          onPressed: onGoogleLogin,
        ),
        const SizedBox(height: 16),

        // Dòng chú thích — terms
        Text(
          'Bằng cách đăng nhập, bạn đồng ý với chính sách bảo mật của Design a Bear.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: const Color(0xFF9CA3AF),
            height: 1.65,
          ),
        ),
      ],
    );
  }
}
