import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'google_login_button.dart';

class LoginAuthCard extends StatelessWidget {
  final bool isLoading;
  final bool hasError;
  final String errorMessage;
  final VoidCallback onGoogleLogin;

  const LoginAuthCard({
    super.key,
    required this.isLoading,
    required this.hasError,
    required this.errorMessage,
    required this.onGoogleLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04), // Bóng vô cùng nhẹ (theo UI Skill)
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Vừa đủ chiều cao
        children: [
          Text(
            'Design a Bear',
            style: GoogleFonts.beVietnamPro(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1A1A2E), // textPrimary
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Người bạn thông minh của bé',
            style: GoogleFonts.beVietnamPro(
              fontSize: 16,
              color: const Color(0xFF6B7280), // textSecondary
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 32),

          // Hiển thị khung Error nếu đăng nhập xịt
          if (hasError)
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B9D).withOpacity(0.1), // accentPink pha loãng
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFFF6B9D).withOpacity(0.3), 
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline,
                      color: Color(0xFFFF6B9D), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      errorMessage,
                      style: GoogleFonts.beVietnamPro(
                        color: const Color(0xFF1A1A2E), // Text primary
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Nút đăng nhập Custom
          GoogleLoginButton(
            isLoading: isLoading,
            onPressed: onGoogleLogin,
          ),
          const SizedBox(height: 24),

          // Chính sách bảo mật
          Text(
            'Bằng cách đăng nhập, bạn đồng ý với\nChính sách bảo mật của Design a Bear',
            textAlign: TextAlign.center,
            style: GoogleFonts.beVietnamPro(
              color: const Color(0xFF9CA3AF), // textMuted
              fontSize: 12,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
