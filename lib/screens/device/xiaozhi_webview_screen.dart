import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_settings/app_settings.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import '../../widgets/aura_background.dart';
import 'widgets/connect_tutorial_stage.dart';
import 'widgets/connect_webview_toolbar.dart';

/// In-app mini browser for Xiaozhi WiFi captive portal configuration (V3.8 Navy/Light Theme).
class XiaozhiWebViewScreen extends StatefulWidget {
  const XiaozhiWebViewScreen({super.key});

  @override
  State<XiaozhiWebViewScreen> createState() => _XiaozhiWebViewScreenState();
}

class _XiaozhiWebViewScreenState extends State<XiaozhiWebViewScreen>
    with TickerProviderStateMixin {
  static const String _captivePortalUrl = 'http://192.168.4.1';

  // Design Tokens
  final Color primaryColor = const Color(0xFF17409A); // Navy
  final Color accentWarm = const Color(0xFFFF8C42);  // Orange
  final Color backgroundColor = const Color(0xFFF4F7FF);
  final Color textPrimary = const Color(0xFF1A1A2E);

  // Tutorial state
  bool _showTutorial = true;
  int _tutorialStep = 0;

  // WebView state
  late final WebViewController _webController;
  bool _isPageLoading = true;
  bool _pageLoadError = false;
  int _loadingProgress = 0;

  late final _tutorialSteps = [
    _TutorialStep(
      icon: Icons.power_rounded,
      title: 'Chuẩn bị Gấu',
      body: 'Giữ nút trên Gấu khoảng 5 giây cho đến khi '
          'nghe tiếng "Đang vào chế độ cấu hình WiFi". Gấu sẽ phát WiFi tên "SmartBear-XXXXXX".',
      color: primaryColor,
    ),
    _TutorialStep(
      icon: Icons.wifi_find_rounded,
      title: 'Kết nối WiFi Gấu',
      body: 'Vào Cài đặt → WiFi trên điện thoại. '
          'Chọn mạng WiFi có tên bắt đầu bằng "SmartBear-" và kết nối vào đó.',
      color: accentWarm,
    ),
    _TutorialStep(
      icon: Icons.open_in_browser_rounded,
      title: 'Cài WiFi qua App',
      body: 'Nhấn "Mở trình duyệt" bên dưới. Trang cài đặt sẽ hiển thị. '
          'Chọn WiFi nhà bạn và nhập mật khẩu, sau đó ấn "Connect".',
      color: const Color(0xFF7C5CFC),
    ),
    _TutorialStep(
      icon: Icons.check_circle_rounded,
      title: 'Hoàn thành!',
      body: 'Sau khi Gấu kết nối thành công, nó sẽ nói một mã 6 chữ số. '
          'Quay lại màn hình trước và nhập mã đó để kết thúc.',
      color: Colors.green,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (p) => setState(() => _loadingProgress = p),
        onPageStarted: (_) => setState(() {
          _isPageLoading = true;
          _pageLoadError = false;
        }),
        onPageFinished: (_) => setState(() => _isPageLoading = false),
        onWebResourceError: (_) => setState(() {
          _isPageLoading = false;
          _pageLoadError = true;
        }),
      ));
  }

  Future<void> _openWifiSettings() async {
    try {
      await AppSettings.openAppSettings(type: AppSettingsType.wifi);
    } catch (e) {
      await AppSettings.openAppSettings();
    }
  }

  Future<void> _showWifiPicker() async {
    // 1. Check permissions first
    final status = await Permission.location.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng cấp quyền Vị trí để quét WiFi của Gấu.'))
      );
      return;
    }

    // 2. Start scanning
    setState(() => _isPageLoading = true); // Reuse loading state for a moment
    final canScan = await WiFiScan.instance.canStartScan();
    if (canScan != CanStartScan.yes) {
      _openWifiSettings();
      setState(() => _isPageLoading = false);
      return;
    }

    await WiFiScan.instance.startScan();
    final results = await WiFiScan.instance.getScannedResults();
    setState(() => _isPageLoading = false);

    if (!mounted) return;

    // 3. Show Bottom Sheet
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildWifiPickerSheet(results),
    );
  }

  Widget _buildWifiPickerSheet(List<WiFiAccessPoint> results) {
    final xiaozhiNets = results.where((ap) => ap.ssid.toLowerCase().contains('smartbear')).toList();
    final otherNets = results.where((ap) => !ap.ssid.toLowerCase().contains('smartbear')).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Text('Chọn WiFi của Gấu', style: GoogleFonts.beVietnamPro(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
          const SizedBox(height: 8),
          Text('Kết nối vào mạng "SmartBear-XXXX" để tiếp tục', style: GoogleFonts.beVietnamPro(fontSize: 13, color: Colors.grey[500])),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                if (xiaozhiNets.isEmpty)
                   Padding(
                     padding: const EdgeInsets.symmetric(vertical: 32),
                     child: Column(
                       children: [
                         Icon(Icons.wifi_find_rounded, size: 48, color: Colors.grey[300]),
                         const SizedBox(height: 16),
                         Text('Không tìm thấy Gấu nào xung quanh...', style: GoogleFonts.beVietnamPro(color: Colors.grey[500])),
                         TextButton(onPressed: _openWifiSettings, child: const Text('Mở cài đặt hệ thống')),
                       ],
                     ),
                   ),
                
                ...xiaozhiNets.map((ap) => _buildWifiListTile(ap, isGau: true)),
                if (otherNets.isNotEmpty) ...[
                  const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider()),
                  Text('CÁC MẠNG KHÁC', style: GoogleFonts.beVietnamPro(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey[400], letterSpacing: 1)),
                  const SizedBox(height: 12),
                ],
                ...otherNets.take(10).map((ap) => _buildWifiListTile(ap, isGau: false)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWifiListTile(WiFiAccessPoint ap, {required bool isGau}) {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        _openWifiSettings();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vui lòng chọn "${ap.ssid}" trong cài đặt WiFi.'))
        );
      },
      leading: Icon(isGau ? Icons.pets_rounded : Icons.wifi_rounded, color: isGau ? const Color(0xFF7C5CFC) : Colors.grey[400]),
      title: Text(ap.ssid, style: GoogleFonts.beVietnamPro(fontWeight: isGau ? FontWeight.w800 : FontWeight.w500, color: isGau ? const Color(0xFF7C5CFC) : textPrimary)),
      trailing: isGau ? const Icon(Icons.arrow_forward_ios_rounded, size: 14) : Text('${ap.level} dBm', style: const TextStyle(fontSize: 10, color: Colors.grey)),
    );
  }

  void _nextTutorialStep() {
    if (_tutorialStep < _tutorialSteps.length - 1) {
      setState(() => _tutorialStep++);
    }
  }

  void _prevTutorialStep() {
    if (_tutorialStep > 0) {
      setState(() => _tutorialStep--);
    }
  }

  void _launchBrowser() {
    setState(() => _showTutorial = false);
    _webController.loadRequest(Uri.parse(_captivePortalUrl));
  }

  void _reload() {
    setState(() {
      _pageLoadError = false;
      _isPageLoading = true;
    });
    _webController.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AuraBackground(),
          _showTutorial ? _buildTutorial() : _buildBrowser(),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────
  // TUTORIAL
  // ─────────────────────────────────────────────────────

  Widget _buildTutorial() {
    final step = _tutorialSteps[_tutorialStep];
    final isLast = _tutorialStep == _tutorialSteps.length - 1;

    return SafeArea(
      child: Column(
        children: [
          // Custom Nav Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.close_rounded, color: textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    'Hướng dẫn kết nối',
                    style: GoogleFonts.beVietnamPro(
                      color: textPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),

          // Step Progress
          const SizedBox(height: 16),
          _buildStepProgress(),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Column(
                children: [
                  ConnectTutorialStage(
                    step: _tutorialStep,
                    totalSteps: _tutorialSteps.length,
                    icon: step.icon,
                    title: step.title,
                    body: step.body,
                    color: step.color,
                    textPrimary: textPrimary,
                  ),
                ],
              ),
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(32),
            child: _buildTutorialFooter(isLast, step.color),
          ),
        ],
      ),
    );
  }

  Widget _buildStepProgress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_tutorialSteps.length, (i) {
        final active = i == _tutorialStep;
        return AnimatedContainer(
          duration: 300.ms,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 24 : 8,
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: active ? _tutorialSteps[i].color : textPrimary.withOpacity(0.1),
          ),
        );
      }),
    );
  }

  Widget _buildTutorialFooter(bool isLast, Color stepColor) {
    return Column(
      children: [
        if (isLast)
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _launchBrowser,
              style: FilledButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.open_in_browser_rounded),
              label: Text(
                'MỞ TRÌNH DUYỆT CÀI ĐẶT',
                style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w900),
              ),
            ),
          )
        else
          SizedBox(
            width: double.infinity,
              child: FilledButton.icon(
                onPressed: _tutorialStep == 1 ? _showWifiPicker : _nextTutorialStep,
                style: FilledButton.styleFrom(
                  backgroundColor: stepColor,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: Icon(_tutorialStep == 1 ? Icons.wifi_find_rounded : Icons.arrow_forward_rounded),
                label: Text(
                  _tutorialStep == 1 ? 'MỞ DANH SÁCH WIFI' : 'TIẾP TỤC',
                  style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w900, letterSpacing: 1),
                ),
              ).animate(onPlay: (c) => _tutorialStep == 1 ? c.repeat(reverse: true) : null)
               .shimmer(duration: 2.seconds, color: Colors.white.withOpacity(0.2)),
          ),

        // "Tiếp tục" button at step 1 to skip ahead after successful WiFi connection
        if (_tutorialStep == 1) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _nextTutorialStep,
              style: OutlinedButton.styleFrom(
                foregroundColor: stepColor,
                side: BorderSide(color: stepColor.withOpacity(0.4), width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.arrow_forward_rounded, size: 20),
              label: Text(
                'TIẾP TỤC',
                style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w800, letterSpacing: 1),
              ),
            ),
          ),
        ],

        if (_tutorialStep > 0) ...[
          const SizedBox(height: 16),
          TextButton(
            onPressed: _prevTutorialStep,
            child: Text(
              'Quay lại',
              style: GoogleFonts.beVietnamPro(color: textPrimary.withOpacity(0.4), fontWeight: FontWeight.bold),
            ),
          ),
        ],

        if (_tutorialStep == 0) ...[
          const SizedBox(height: 16),
          TextButton(
            onPressed: _launchBrowser,
            child: Text(
              'Bỏ qua hướng dẫn kỹ thuật',
              style: GoogleFonts.beVietnamPro(color: textPrimary.withOpacity(0.3), fontSize: 13),
            ),
          ),
        ],
      ],
    );
  }

  // ─────────────────────────────────────────────────────
  // MINI BROWSER
  // ─────────────────────────────────────────────────────

  Widget _buildBrowser() {
    return SafeArea(
      child: Column(
        children: [
          ConnectWebviewToolbar(
            url: _captivePortalUrl,
            backgroundColor: backgroundColor,
            textPrimary: textPrimary,
            onBack: () async {
              if (await _webController.canGoBack()) {
                _webController.goBack();
              } else {
                setState(() => _showTutorial = true);
              }
            },
            onReload: _reload,
            onConfirm: () => Navigator.pop(context, true),
          ),
          if (_isPageLoading)
            LinearProgressIndicator(
              value: _loadingProgress / 100,
              backgroundColor: Colors.transparent,
              color: accentWarm,
              minHeight: 3,
            ),
          Expanded(
            child: _pageLoadError
                ? _buildErrorView()
                : Stack(
                    children: [
                      WebViewWidget(controller: _webController),
                      if (_isPageLoading && _loadingProgress < 10)
                        _buildInitialLoadingView(),
                    ],
                  ),
          ),
          _buildBottomHint(),
        ],
      ),
    );
  }

  Widget _buildInitialLoadingView() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(strokeWidth: 3),
            const SizedBox(height: 24),
            Text(
              'Đang tìm Gấu...',
              style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold, color: textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'Hãy chắc chắn bạn đang kết nối vào\nWiFi "SmartBear-XXXXXX"',
              textAlign: TextAlign.center,
              style: GoogleFonts.beVietnamPro(fontSize: 12, color: textPrimary.withOpacity(0.4)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 80, color: Colors.red[300]),
            const SizedBox(height: 24),
            Text(
              'Không thấy Gấu phản hồi',
              style: GoogleFonts.beVietnamPro(fontSize: 20, fontWeight: FontWeight.w900, color: textPrimary),
            ),
            const SizedBox(height: 12),
            Text(
              'Hãy kiểm tra lại xem điện thoại đã kết nối vào WiFi của Gấu chưa nhé.',
              textAlign: TextAlign.center,
              style: GoogleFonts.beVietnamPro(color: textPrimary.withOpacity(0.5), height: 1.6),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _reload,
                child: const Text('Thử lại'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomHint() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: textPrimary.withOpacity(0.05))),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline_rounded, size: 18, color: accentWarm),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Chọn WiFi nhà → Nhập mật khẩu → Connect → Bấm ✔ khi xong.',
              style: GoogleFonts.beVietnamPro(fontSize: 11, color: textPrimary.withOpacity(0.4), fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// DATA CLASS
// ─────────────────────────────────────────────────────

class _TutorialStep {
  final IconData icon;
  final String title;
  final String body;
  final Color color;

  const _TutorialStep({
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
  });
}
