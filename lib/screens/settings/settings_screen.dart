import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/auth_service.dart';
import '../../data/api/payment_api.dart';
import '../../data/models/response/payment_response.dart';
import '../premium/subscription_screen.dart';
import '../safety/safety_settings_screen.dart';
import '../../services/theme_service.dart';
// import 'library_preview_screen.dart';

// Import local widgets
import 'widgets/settings_header.dart';
import 'widgets/user_info_card.dart';
import 'widgets/settings_menu_tile.dart';
import 'widgets/subscription_status_card.dart';
import 'widgets/settings_loading_view.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback? onLogout;

  const SettingsScreen({super.key, this.onLogout});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _authService = AuthService();
  final _paymentApi = PaymentApi();
  
  Map<String, dynamic>? _currentUser;
  SubscriptionStatusModel? _subStatus;
  bool _isMainLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _isMainLoading = true);
    _currentUser = _authService.currentUser;
    await _loadSubStatus();
    if (mounted) setState(() => _isMainLoading = false);
  }

  Future<void> _loadSubStatus() async {
    final status = await _paymentApi.getSubscriptionStatus();
    if (mounted) setState(() => _subStatus = status.value);
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text('Đăng xuất', style: GoogleFonts.fredoka(fontWeight: FontWeight.w700)),
        content: Text('Bạn có chắc muốn đăng xuất không?', style: GoogleFonts.inter()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('HỦY', style: GoogleFonts.inter(fontWeight: FontWeight.w800, color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('ĐĂNG XUẤT', style: GoogleFonts.inter(fontWeight: FontWeight.w800, color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _authService.logout();
      if (mounted) {
        // Clear navigation stack and go back to root (AuthGate)
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        widget.onLogout?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Aura Background
          _buildAuraBlobs(),

          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 120, sigmaY: 120),
              child: Container(color: Colors.transparent),
            ),
          ),

          // Content
          SafeArea(
            child: _isMainLoading 
              ? const SettingsLoadingView()
              : Column(
                  children: [
                    SettingsHeader(onBack: () => Navigator.pop(context)),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_currentUser != null)
                              UserInfoCard(
                                user: _currentUser!, 
                                isPro: _subStatus?.isPro == true,
                              ).animate().fadeIn().slideY(begin: 0.1),
                            
                             const SizedBox(height: 32),
                             Text(
                               'QUẢN LÝ TÀI KHOẢN',
                               style: GoogleFonts.beVietnamPro(
                                 fontSize: 11, 
                                 fontWeight: FontWeight.w900, 
                                 color: Colors.grey[400], 
                                 letterSpacing: 2.0,
                                 height: 1.4,
                               ),
                             ),
                            const SizedBox(height: 20),

                            SubscriptionStatusCard(
                              isPro: _subStatus?.isPro == true,
                              planName: _subStatus?.planName,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const SubscriptionScreen())
                                );
                                _loadSubStatus();
                              },
                            ),
                            const SizedBox(height: 12),
                            ValueListenableBuilder<ThemeMode>(
                              valueListenable: ThemeService().themeNotifier,
                              builder: (context, mode, child) {
                                final isDark = mode == ThemeMode.dark;
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardTheme.color ?? Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      )
                                    ],
                                  ),
                                  child: SwitchListTile(
                                    value: isDark,
                                    onChanged: (val) => ThemeService().toggleTheme(val),
                                    title: Text(
                                      'Chế độ tối',
                                      style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w700, fontSize: 15),
                                    ),
                                    subtitle: Text(
                                      'Bật giao diện tối màu',
                                      style: GoogleFonts.beVietnamPro(fontSize: 12, color: Colors.grey),
                                    ),
                                    secondary: Icon(
                                      isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                                      color: isDark ? Colors.amber : Colors.blue,
                                    ),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                    activeColor: const Color(0xFF7C5CFC),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            /*
                            SettingsMenuTile(
                              icon: Icons.library_music_rounded,
                              color: const Color(0xFFFF8C42), // Orange
                              title: 'Kho Nhạc & Truyện',
                              subtitle: 'Nghe thử các bài hát và câu chuyện có sẵn',
                              onTap: () => Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (_) => const LibraryPreviewScreen())
                              ),
                            ).animate().fadeIn(delay: 150.ms).slideX(begin: -0.1),
                            const SizedBox(height: 12),
                            */
                            SettingsMenuTile(
                              icon: Icons.verified_user_rounded,
                              color: const Color(0xFF4ECDC4), // Teal
                              title: 'Trung tâm An toàn',
                              subtitle: 'Lọc nội dung và chặn chủ đề nhạy cảm',
                              onTap: () => Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (_) => const SafetySettingsScreen())
                              ),
                            ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),


                            const SizedBox(height: 48),
                            
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: _handleLogout,
                                icon: const Icon(Icons.logout_rounded, size: 20),
                                label: Text(
                                  'ĐĂNG XUẤT TÀI KHOẢN', 
                                  style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w800, letterSpacing: 0.5),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.redAccent,
                                  side: BorderSide(color: Colors.redAccent.withOpacity(0.2)),
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  backgroundColor: Colors.redAccent.withOpacity(0.04),
                                ),
                              ),
                            ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.95, 0.95)),

                            const SizedBox(height: 60),
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    'SmartBear App',
                                    style: GoogleFonts.beVietnamPro(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.grey[400]),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Phiên bản 1.0.0 (Beta)',
                                    style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[300], fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuraBlobs() {
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 450,
            height: 450,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFF8C42).withOpacity(0.05),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .move(begin: const Offset(0, 0), end: const Offset(-100, 150), duration: 25.seconds),
        ),
        Positioned(
          bottom: -80,
          left: -80,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF7C5CFC).withOpacity(0.04),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .move(begin: const Offset(0, 0), end: const Offset(120, -100), duration: 20.seconds),
        ),
      ],
    );
  }
}
