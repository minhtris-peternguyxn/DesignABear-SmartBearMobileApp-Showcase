import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'payos_webview_screen.dart';
import '../../data/api/payment_api.dart';
import '../../core/network/api_response.dart';
import '../../data/models/response/common_response.dart';
import '../../data/models/response/payment_response.dart';
import '../../widgets/app_toast.dart';
import 'widgets/subscription_hero_banner.dart';
import 'widgets/subscription_plan_card.dart';
import 'widgets/subscription_candy_package.dart';
import 'widgets/subscription_header.dart';
import 'widgets/subscription_skeleton.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen>
    with TickerProviderStateMixin {
  final _paymentApi = PaymentApi();
  final _voucherController = TextEditingController();

  SubscriptionStatusModel? _status;
  List<SubscriptionPlanModel> _plans = [];
  bool _loading = true;
  bool _buyLoading = false;
  String? _voucherFeedback;
  Map<String, dynamic>? _voucherData;

  late AnimationController _shimmerCtrl;
  late Animation<double> _shimmer;

  final Color primaryColor = const Color(0xFF17409A);
  final Color accentWarm = const Color(0xFFFF8C42);
  final Color accentPurple = const Color(0xFF7C5CFC);
  final Color textPrimary = const Color(0xFF1A1A2E); // Note: We'll use Theme text color instead

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _shimmer = CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut);
    _loadData();
  }

  @override
  void dispose() {
    _voucherController.dispose();
    _shimmerCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait<ApiResponse<dynamic>>([
        _paymentApi.getSubscriptionStatus(),
        _paymentApi.getSubscriptionPlans(),
      ]);

      if (mounted) {
        final statusRes = results[0] as ApiResponse<SubscriptionStatusModel>;
        final plansRes = results[1] as ApiResponse<List<SubscriptionPlanModel>>;
        
        setState(() {
          _status = statusRes.value;
          _plans = plansRes.value ?? [];
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _handleBuyPlan(int planType) async {
    setState(() { _buyLoading = true; _voucherFeedback = null; });
    final response = await _paymentApi.createPaymentQR(
      planType: planType,
      voucherCode: _voucherController.text.trim().isEmpty ? null : _voucherController.text.trim(),
    );
    setState(() => _buyLoading = false);
    if (!response.isSuccess) {
      if (mounted) AppToast.show(context, response.error?.description ?? 'Có lỗi xảy ra', type: ToastType.error);
      return;
    }
    final url = response.value?.checkoutUrl;
    if (url != null && mounted) await _openCheckout(url);
  }

  Future<void> _handleBuyCandy(int id) async {
    setState(() { _buyLoading = true; _voucherFeedback = null; });
    final response = await _paymentApi.createCandyPaymentQR(
      candyPackId: id,
      voucherCode: _voucherController.text.trim().isEmpty ? null : _voucherController.text.trim(),
    );
    setState(() => _buyLoading = false);
    if (!response.isSuccess) {
      if (mounted) AppToast.show(context, response.error?.description ?? 'Có lỗi xảy ra', type: ToastType.error);
      return;
    }
    final url = response.value?.checkoutUrl;
    if (url != null && mounted) await _openCheckout(url);
  }

  Future<void> _openCheckout(String url) async {
    final status = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PayosWebviewScreen(url: url),
    );
    if (status == 'success' && mounted) {
      AppToast.show(context, 'Thanh toán thành công!', type: ToastType.success);
    }
    if (mounted) await _loadData();
  }

  Future<void> _handleValidateVoucher(int targetAmount) async {
    final code = _voucherController.text.trim();
    if (code.isEmpty) return;
    setState(() { _buyLoading = true; _voucherFeedback = null; _voucherData = null; });
    
    final cleanCode = code.toUpperCase().replaceAll(' ', '');
    final res = await _paymentApi.validateVoucher(cleanCode, targetAmount);
    
    setState(() => _buyLoading = false);
    if (res.isSuccess) {
      setState(() { _voucherData = res.value?.data; _voucherFeedback = null; });
      if (mounted) AppToast.show(context, 'Áp dụng mã thành công!');
    } else {
      setState(() { _voucherFeedback = res.error?.description; _voucherData = null; });
      if (mounted) AppToast.show(context, res.error?.description ?? 'Mã không hợp lệ', type: ToastType.error);
    }
  }

  String _formatPrice(dynamic n) {
    final v = (n is int) ? n : (int.tryParse('$n') ?? 0);
    final s = v.toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return s.replaceAllMapped(reg, (Match m) => '${m[1]}.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Aura Background
          _buildAuraBackground(),

          SafeArea(
            child: _loading
              ? Column(
                  children: [
                    SubscriptionHeader(onBack: () => Navigator.pop(context), onRefresh: _loadData),
                    const Expanded(child: SubscriptionSkeleton()),
                  ],
                )
              : CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: SubscriptionHeader(
                        onBack: () => Navigator.pop(context),
                        onRefresh: _loadData,
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          SubscriptionHeroBanner(
                            status: _status,
                            shimmer: _shimmer,
                          ),
                          const SizedBox(height: 48),
                          _buildSectionLabel('HẠNG DỊCH VỤ PREMIUM'),
                          const SizedBox(height: 20),
                          _buildPlanCards(),
                          const SizedBox(height: 48),
                          _buildSectionLabel('BỔ SUNG KẸO LẺ'),
                          const SizedBox(height: 6),
                          Text(
                            'Kẹo không bao giờ hết hạn · Sử dụng linh hoạt',
                            style: GoogleFonts.beVietnamPro(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildCandySection(),
                          const SizedBox(height: 100),
                        ]),
                      ),
                    ),
                  ],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuraBackground() {
    return Stack(
      children: [
        // Layer 1: Navy Soft Glow
        Positioned(
          top: -100,
          left: -50,
          child: _orb(500, primaryColor, 0.08),
        ).animate(onPlay: (c) => c.repeat(reverse: true))
         .move(begin: const Offset(0, 0), end: const Offset(40, 60), duration: 12.seconds),
        
        // Layer 2: Warm Orange Glow (Vitality)
        Positioned(
          top: 150,
          right: -150,
          child: _orb(450, accentWarm, 0.1),
        ).animate(onPlay: (c) => c.repeat(reverse: true))
         .move(begin: const Offset(0, 0), end: const Offset(-80, 40), duration: 18.seconds),

        // Layer 3: Purple Soft Glow (Luxury)
        Positioned(
          bottom: 50,
          left: -100,
          child: _orb(400, accentPurple, 0.06),
        ).animate(onPlay: (c) => c.repeat(reverse: true))
         .move(begin: const Offset(0, 0), end: const Offset(60, -30), duration: 15.seconds),

        // Layer 4: Center Blur Blend
        Positioned.fill(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(color: Colors.transparent),
          ),
        ),
      ],
    );
  }

  Widget _orb(double size, Color color, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(opacity),
            color.withOpacity(opacity * 0.5),
            Colors.transparent,
          ],
          stops: const [0.2, 0.5, 1.0],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.beVietnamPro(
        color: primaryColor,
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 2.0,
      ),
    );
  }

  Widget _buildPlanCards() {
    final isPro = _status?.isPro ?? false;

    int _planPrice(String planTypeName, int fallback) {
      try {
        final match = _plans.firstWhere((p) => 
          p.planType.toLowerCase() == planTypeName.toLowerCase() ||
          p.name.toLowerCase().contains(planTypeName.toLowerCase())
        );
        return (match.priceMonthly != null && match.priceMonthly! > 0) ? match.priceMonthly! : fallback;
      } catch (_) { return fallback; }
    }

    String _priceLabel(int amount, {bool isFree = false}) {
      if (isFree || amount == 0) return 'Miễn phí';
      return '${_formatPrice(amount)}đ';
    }

    final premiumPrice = _planPrice('premium', 100000);
    final ultraPrice = _planPrice('vip', 350000);

    final plans = [
      PlanData(
        icon: Icons.eco_rounded,
        name: 'Gói Cơ Bản',
        price: 'Miễn phí',
        sub: '',
        color: const Color(0xFF64748B),
        badge: isPro ? null : 'HIỆN TẠI',
        isCurrent: !isPro,
        canBuy: false,
        features: ['10 kẹo / ngày mỗi Gấu', 'Nhạc thiếu nhi & Truyện kể', 'AI đàm thoại cơ bản'],
        locked: ['Toán tư duy & Tiếng Anh', 'Giọng đọc Pro ElevenLabs'],
        originalAmountOverride: 0,
      ),
      PlanData(
        icon: Icons.star_rounded,
        name: 'Gói Nâng Cao',
        price: _priceLabel(premiumPrice),
        sub: '/tháng',
        color: primaryColor,
        badge: (_status?.planName?.contains('Nâng Cao') == true) ? 'HIỆN TẠI' : (isPro ? null : 'PHỔ BIẾN'),
        isCurrent: _status?.planName?.contains('Nâng Cao') == true, 
        canBuy: !isPro,
        features: [
          '50 kẹo / ngày mỗi Gấu',
          'Toán tư duy & Tiếng Anh Premium',
          'Truyện AI kể theo yêu cầu',
          'Giọng Pro (GCP & ElevenLabs)',
        ],
        locked: [],
        originalAmountOverride: premiumPrice,
      ),
      PlanData(
        icon: Icons.military_tech_rounded,
        name: 'Gói Ultra',
        price: _priceLabel(ultraPrice),
        sub: '/tháng',
        color: accentPurple,
        badge: (_status?.planName?.contains('Ultra') == true) ? 'HIỆN TẠI' : 'TỐI ƯU NHẤT',
        isCurrent: _status?.planName?.contains('Ultra') == true,
        canBuy: !(_status?.planName?.contains('Ultra') == true),
        features: ['300 kẹo / ngày', 'Toàn bộ nội dung Pro', 'Hỗ trợ ưu tiên riêng biệt'],
        locked: [],
        originalAmountOverride: ultraPrice,
      ),
    ];

    return Column(
      children: plans.asMap().entries.map((e) {
        final i = e.key;
        final p = e.value;
        return PlanCard(
          p: p,
          buyLoading: _buyLoading,
          onBuyTap: () => _showPurchaseDrawer(
            title: p.name,
            priceLabel: '${p.price}${p.sub}',
            icon: p.icon,
            color: p.color,
            isCandy: false,
            actualAmount: p.originalAmountOverride,
            onConfirm: () => _handleBuyPlan(p.name.contains('Ultra') ? 3 : 2),
          ),
        ).animate().fadeIn(delay: (200 * i).ms).slideY(begin: 0.1, curve: Curves.easeOut);
      }).toList(),
    );
  }

  Widget _buildCandySection() {
    final packs = [
      (1, '50 Kẹo Bổ Sung', 'Gói Bé', '20.000đ'),
      (2, '100 Kẹo Bổ Sung', 'Gói Vừa', '40.000đ'),
      (3, '500 Kẹo Bổ Sung', 'Gói Lớn', '180.000đ'),
    ];

    return Column(
      children: packs.asMap().entries.map((e) {
        final i = e.key;
        final (id, label, name, price) = e.value;
        return SubscriptionCandyPackage(
          id: id,
          label: label,
          name: name,
          price: price,
          isPopular: i == 2,
          buyLoading: _buyLoading,
          onBuyTap: () => _showPurchaseDrawer(
            title: name,
            priceLabel: price,
            icon: Icons.stars_rounded,
            color: accentWarm,
            isCandy: true,
            actualAmount: int.tryParse(price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
            onConfirm: () => _handleBuyCandy(id),
          ),
        ).animate().fadeIn(delay: (600 + 100 * i).ms).slideX(begin: 0.1, curve: Curves.easeOut);
      }).toList(),
    );
  }

  Future<void> _showPurchaseDrawer({
    required String title,
    required String priceLabel,
    required IconData icon,
    required Color color,
    required bool isCandy,
    required int actualAmount,
    required VoidCallback onConfirm,
  }) async {
    _voucherController.clear();
    setState(() { _voucherData = null; _voucherFeedback = null; });

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.95),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(height: 24),
                      
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                            child: Icon(icon, color: color, size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title, style: GoogleFonts.beVietnamPro(textStyle: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color, fontWeight: FontWeight.w900, fontSize: 18))),
                                Text('Xác nhận mua hàng', style: GoogleFonts.beVietnamPro(textStyle: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 13))),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(color: Color(0xFFE5E7EB)),
                      const SizedBox(height: 24),
      
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _voucherController,
                              textCapitalization: TextCapitalization.characters,
                              style: GoogleFonts.beVietnamPro(textStyle: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                              onChanged: (_) {
                                if (_voucherData != null || _voucherFeedback != null) {
                                  setModalState(() { _voucherData = null; _voucherFeedback = null; });
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'MÃ GIẢM GIÁ (NẾU CÓ)',
                                hintStyle: GoogleFonts.beVietnamPro(textStyle: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 11, letterSpacing: 0.5)),
                                filled: true, fillColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: _buyLoading ? null : () async {
                              await _handleValidateVoucher(actualAmount);
                              setModalState(() {}); 
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color.withOpacity(0.1), foregroundColor: color, elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: color.withOpacity(0.3))),
                            ),
                            child: const Text('Dùng'),
                          ),
                        ],
                      ),
      
                      if (_voucherFeedback != null) ...[
                        const SizedBox(height: 8),
                        Text(_voucherFeedback!, style: GoogleFonts.beVietnamPro(textStyle: const TextStyle(color: Color(0xFFEF4444), fontSize: 11))),
                      ],
      
                      const SizedBox(height: 24),
      
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.02), 
                          borderRadius: BorderRadius.circular(20), 
                          border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1))
                        ),
                        child: Column(
                          children: [
                            _priceRow('Giá niêm yết', _voucherData != null ? '${_formatPrice(_voucherData!['originalAmount'])}đ' : priceLabel),
                            if (_voucherData != null) ...[
                              _priceRow('Giảm giá', '-${_formatPrice(_voucherData!['discountAmount'])}đ', color: const Color(0xFF22C55E)),
                              const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(color: Color(0xFFE5E7EB))),
                              _priceRow('Tổng cộng', '${_formatPrice(_voucherData!['finalAmount'])}đ', bold: true),
                            ] else ...[
                              const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(color: Color(0xFFE5E7EB))),
                              _priceRow('Tổng cộng', priceLabel, bold: true),
                            ],
                          ],
                        ),
                      ),
      
                      const SizedBox(height: 32),
      
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: _buyLoading ? null : () { Navigator.pop(ctx); onConfirm(); },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color, foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            elevation: 8, shadowColor: color.withOpacity(0.3),
                          ),
                          child: const Text('XÁC NHẬN THANH TOÁN', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: 1)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _priceRow(String label, String val, {Color? color, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.beVietnamPro(textStyle: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 13, fontWeight: FontWeight.w500))),
          Text(val, style: GoogleFonts.beVietnamPro(textStyle: TextStyle(
            color: color ?? (bold ? Theme.of(context).textTheme.titleLarge?.color : Theme.of(context).textTheme.bodyLarge?.color),
            fontSize: bold ? 17 : 13,
            fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
          ))),
        ],
      ),
    );
  }
}
