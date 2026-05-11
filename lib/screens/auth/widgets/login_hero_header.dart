import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Hero section chiếm phần lớn màn hình — Logo + tagline
class LoginHeroHeader extends StatefulWidget {
  const LoginHeroHeader({super.key});

  @override
  State<LoginHeroHeader> createState() => _LoginHeroHeaderState();
}

class _LoginHeroHeaderState extends State<LoginHeroHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;
  late final Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo — ảnh trên nền transparent, không có nền tròn xanh
        AnimatedBuilder(
          animation: _floatAnimation,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: child,
          ),
          child: _buildLogo(),
        ),
        const SizedBox(height: 32),

        // Tên app — Headline Large, font Fredoka, màu Primary Navy
        Text(
          'SmartBear',
          style: GoogleFonts.beVietnamPro(
            fontSize: 42,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF17409A),
            letterSpacing: -1.0,
          ),
        ),
        const SizedBox(height: 8),

        // Tagline — Be Vietnam Pro, xám mềm
        Text(
          'Người bạn thông minh của bé',
          style: GoogleFonts.beVietnamPro(
            fontSize: 16,
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    // Kiểm tra nếu file logo tồn tại; nếu chưa có thì dùng placeholder icon
    return _LogoWithFallback();
  }
}

/// Widget logo: thử load ảnh từ assets trước, nếu lỗi thì hiển thị icon placeholder
class _LogoWithFallback extends StatelessWidget {
  const _LogoWithFallback();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback: icon gấu trên nền transparent (không nền tròn xanh)
          return const Icon(
            Icons.pets,
            size: 96,
            color: Color(0xFF17409A), // Logo màu xanh Navy
          );
        },
      ),
    );
  }
}
