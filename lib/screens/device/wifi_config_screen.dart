import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/api/device_api.dart';
import '../../widgets/aura_background.dart';
import 'widgets/wifi_progress_bar.dart';
import 'widgets/wifi_step_card.dart';
import 'widgets/wifi_pairing_section.dart';
import 'widgets/wifi_success_view.dart';
import 'xiaozhi_webview_screen.dart';

class WifiConfigScreen extends StatefulWidget {
  const WifiConfigScreen({super.key});

  @override
  State<WifiConfigScreen> createState() => _WifiConfigScreenState();
}

class _WifiConfigScreenState extends State<WifiConfigScreen> {
  final _deviceApi = DeviceApi();

  // Design Tokens
  final Color primaryColor = const Color(0xFF17409A); // Navy
  final Color accentWarm = const Color(0xFFFF8C42);  // Orange
  final Color accentPurple = const Color(0xFF7C5CFC);
  final Color backgroundColor = const Color(0xFFF4F7FF);
  final Color textPrimary = const Color(0xFF1A1A2E);
  
  final _formKey = GlobalKey<FormState>();

  int _currentStep = 0;
  bool _isLoading = false;
  bool _isRequestingOtp = false;

  // Pairing Data
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _childNameController = TextEditingController();
  final TextEditingController _macController = TextEditingController();
  
  String _statusMessage = '';
  bool _pairSuccess = false;
  Map<String, dynamic>? _pairedDevice;

  // Online Status (Always true to bypass check)
  bool _isCheckingOnline = false;
  bool _isDeviceOnline = true;
  
  // Pairing Lockout (10s)
  bool _isPairingLocked = false;
  int _lockSeconds = 0;
  Timer? _lockTimer;

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    _lockTimer?.cancel();
    _codeController.dispose();
    _nicknameController.dispose();
    _childNameController.dispose();
    _macController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AuraBackground(),
          SafeArea(
            child: _pairSuccess 
              ? WifiSuccessView(
                  pairedDevice: _pairedDevice ?? {'deviceNickname': _nicknameController.text},
                  onFinish: () => Navigator.pop(context),
                  primaryColor: primaryColor,
                  textPrimary: textPrimary,
                )
              : Form(
                  key: _formKey,
                  child: _buildMainFlow(),
                ),
          ),
          if (_isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildMainFlow() {
    return Column(
      children: [
        _buildAppBar(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 16),
                WifiProgressBar(currentStep: _currentStep, totalSteps: 2, primaryColor: primaryColor),
                const SizedBox(height: 32),
                
                // Step 1: Open Instruction
                WifiStepCard(
                  step: 0,
                  currentStep: _currentStep,
                  icon: Icons.lightbulb_outline_rounded,
                  title: 'Xem hướng dẫn cài đặt',
                  description: 'Nhấn vào nút bên dưới để xem các bước chuẩn bị Gấu và kết nối WiFi.',
                  actionLabel: 'XEM HƯỚNG DẪN & CÀI ĐẶT',
                  primaryColor: primaryColor,
                  textPrimary: textPrimary,
                  onAction: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const XiaozhiWebViewScreen()),
                    );
                    if (result == true) setState(() => _currentStep = 1);
                  },
                ),

                // Step 2: Input Info & Pair
                WifiStepCard(
                  step: 1,
                  currentStep: _currentStep,
                  icon: Icons.sync_rounded,
                  title: 'Xác nhận & Ghép đôi',
                  description: 'Nhập mã xác nhận 6 chữ số Gấu vừa đọc để hoàn tất việc ghép đôi.',
                  actionLabel: _isLoading 
                      ? 'ĐANG XỬ LÝ...' 
                      : (_isPairingLocked ? 'ĐỢI GẤU ĐỌC MÃ (${_lockSeconds}s)' : 'TIẾN HÀNH GHÉP ĐÔI'),
                  primaryColor: _isPairingLocked ? Colors.grey : primaryColor,
                  textPrimary: textPrimary,
                  onBack: () => setState(() => _currentStep = 0),
                  onAction: (_isPairingLocked || _isLoading) ? () {} : () {
                    if (_formKey.currentState!.validate()) {
                      _handlePairing();
                    }
                  },
                  child: WifiPairingSection(
                    codeController: _codeController,
                    nicknameController: _nicknameController,
                    childNameController: _childNameController,
                    macController: _macController,
                    isRequestingOtp: _isRequestingOtp,
                    primaryColor: primaryColor,
                    accentWarm: accentWarm,
                    textPrimary: textPrimary,
                    onRequestOtp: _handleRequestOtp,
                    isDeviceOnline: _isDeviceOnline,
                    isCheckingOnline: _isCheckingOnline,
                    isPairingLocked: _isPairingLocked,
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Text(
            'Kết nối Gấu mới',
            style: GoogleFonts.beVietnamPro(fontSize: 22, fontWeight: FontWeight.w900, color: Theme.of(context).textTheme.headlineMedium?.color),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text('Đang xử lý...', style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold, color: textPrimary)),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────
  // LOGIC HANDLERS
  // ─────────────────────────────────────────────────────



  Future<void> _handlePairing() async {
    final code = _codeController.text.trim();
    final nickname = _nicknameController.text.trim();
    final childName = _childNameController.text.trim();
    
    if (code.length != 6) {
      _showSnackBar('Mã xác nhận phải đủ 6 chữ số.', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    debugPrint('Pairing: Sending claim request for code: $code');
    
    try {
      final response = await _deviceApi.claimDevice(
        code: code,
        nickname: nickname.isEmpty ? null : nickname,
        childName: childName.isEmpty ? null : childName,
      );

      if (!response.isSuccess) {
        String errorMsg = response.error?.description ?? 'Ghép đôi thất bại.';
        
        if (response.error?.code == 'Device.AlreadyPaired' || response.error?.code == 'Pairing.AlreadyOwned') {
          _showFailureAndGoHome(errorMsg);
          return;
        }

        if (response.error?.code == 'Bridge.BackendUnavailable') {
          errorMsg = 'Máy chủ AI đang bận hoặc chưa khởi động. Bạn hãy kiểm tra lại trên máy tính nhé!';
        } else if (response.error?.code == 'Bridge.ClaimFailed') {
          errorMsg = 'Gấu chưa sẵn sàng nhận mã. Bạn hãy đợi Gấu đọc xong rồi thử lại nhé!';
        }
        _showSnackBar(errorMsg, isError: true);
      } else {
        setState(() {
          _pairSuccess = true;
          final device = response.value;
          _pairedDevice = {
            'deviceId': device?.deviceId,
            'deviceNickname': device?.nickname ?? _nicknameController.text,
          };
        });
      }
    } catch (e) {
      _showSnackBar('Lỗi kết nối: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRequestOtp() async {
    final mac = _macController.text.trim();
    if (mac.isEmpty) {
      _showSnackBar('Vui lòng nhập ID Gấu (MAC) trước.', isError: true);
      return;
    }

    setState(() => _isRequestingOtp = true);
    try {
      // Chờ 5s trước khi gọi để đảm bảo kết nối ổn định (tránh ClientException khi demo)
      await Future.delayed(const Duration(seconds: 5));
      
      final response = await _deviceApi.requestOtp(serialNumber: mac);

      if (response.isSuccess) {
        _showSnackBar('Đã gửi yêu cầu tới Gấu $mac. Bé hãy lắng nghe nhé!');
        // Start 10s lockout
        setState(() {
          _isPairingLocked = true;
          _lockSeconds = 10;
        });
        _lockTimer?.cancel();
        _lockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            if (_lockSeconds > 1) {
              _lockSeconds--;
            } else {
              _isPairingLocked = false;
              _lockTimer?.cancel();
            }
          });
        });
      } else {
        if (response.error?.code == 'Device.AlreadyPaired' || response.error?.code == 'Pairing.AlreadyOwned') {
          _showFailureAndGoHome(response.error?.description ?? 'Thiết bị đã được kết nối với một người dùng khác');
          return;
        }
        _showSnackBar(response.error?.description ?? 'Không thể yêu cầu mã.', isError: true);
      }
    } catch (e) {
      _showSnackBar('Lỗi: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isRequestingOtp = false);
    }
  }

  void _showFailureAndGoHome(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        icon: const Icon(Icons.info_outline_rounded, size: 48, color: Colors.orangeAccent),
        title: Text('Thông báo', style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold)),
        content: Text(message, textAlign: TextAlign.center, style: GoogleFonts.beVietnamPro()),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx); // Đóng dialog
                Navigator.pop(context); // Quay về trang chủ
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('OK QUAY LẠI'),
            ),
          ),
        ],
      ),
    );
  }

  void _showAlreadyOwnedDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        icon: const Icon(Icons.warning_amber_rounded, size: 48, color: Colors.redAccent),
        title: Text('Thiết bị đã có chủ', style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold)),
        content: Text(message, textAlign: TextAlign.center, style: GoogleFonts.beVietnamPro()),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('ĐÃ HIỂU'),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.beVietnamPro(color: Colors.white, fontWeight: FontWeight.w500)),
        backgroundColor: isError ? Colors.redAccent : primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
