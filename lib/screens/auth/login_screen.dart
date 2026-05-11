import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'widgets/login_background.dart';
import 'widgets/login_hero_header.dart';
import 'widgets/login_auth_section.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _authService = AuthService();
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  late final AnimationController _entryController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    ));

    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleLogin() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final success = await _authService.loginWithGoogle();
      if (success) {
        widget.onLoginSuccess();
      } else {
        setState(() {
          _hasError = true;
          _errorMessage = 'Đăng nhập thất bại. Vui lòng thử lại.';
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Không kết nối được hệ thống. Kiểm tra mạng và thử lại.';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FF), // background chuẩn skill
      body: Stack(
        children: [
          // ── Layer 1: Background overlay trang trí (blob + ring) ──
          const LoginBackground(),

          // ── Layer 2: Nội dung chính ──
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Top spacing — logo nằm thoáng
                      SizedBox(height: size.height * 0.12),

                      // ── HeroHeader: Logo + tên app + tagline ──
                      const LoginHeroHeader(),

                      // Spacer đẩy nút đăng nhập xuống đáy
                      const Spacer(),

                      // ── Auth Section (không Card) ──
                      LoginAuthSection(
                        isLoading: _isLoading,
                        hasError: _hasError,
                        errorMessage: _errorMessage,
                        onGoogleLogin: _handleGoogleLogin,
                      ),

                      // Bottom safe padding
                      SizedBox(height: size.height * 0.06),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
