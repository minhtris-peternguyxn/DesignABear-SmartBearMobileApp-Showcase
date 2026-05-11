import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class WifiPairingSection extends StatelessWidget {
  final TextEditingController codeController;
  final TextEditingController nicknameController;
  final TextEditingController childNameController;
  final TextEditingController macController;
  final bool isRequestingOtp;
  final VoidCallback onRequestOtp;
  final Color primaryColor;
  final Color accentWarm;
  final Color textPrimary;
  final bool isDeviceOnline;
  final bool isCheckingOnline;
  final bool isPairingLocked;

  const WifiPairingSection({
    super.key,
    required this.codeController,
    required this.nicknameController,
    required this.childNameController,
    required this.macController,
    required this.isRequestingOtp,
    required this.onRequestOtp,
    required this.primaryColor,
    required this.accentWarm,
    required this.textPrimary,
    required this.isDeviceOnline,
    required this.isCheckingOnline,
    required this.isPairingLocked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'BƯỚC 1: NHẬP ID VÀ LẤY MÃ',
          style: GoogleFonts.beVietnamPro(fontSize: 11, fontWeight: FontWeight.w800, color: primaryColor.withOpacity(0.5), letterSpacing: 1.2),
        ),
        const SizedBox(height: 16),
        
        // ID Input with Integrated Button
        TextFormField(
          controller: macController,
          style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: 'Nhập ID Gấu (Ví dụ: 10:20:BA...)',
            prefixIcon: Icon(Icons.fingerprint_rounded, color: primaryColor.withOpacity(0.5), size: 20),
            suffixIcon: Padding(
              padding: const EdgeInsets.all(6.0),
              child: SizedBox(
                width: 48,
                child: ElevatedButton(
                  onPressed: (isRequestingOtp || isPairingLocked) ? null : onRequestOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPairingLocked ? Colors.grey.shade300 : accentWarm,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: isRequestingOtp 
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.record_voice_over_rounded, size: 20),
                ),
              ),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.5),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: primaryColor.withOpacity(0.1))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: primaryColor.withOpacity(0.05))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: primaryColor, width: 1.5)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (v) => (v == null || v.isEmpty) ? 'Bắt buộc' : null,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (isCheckingOnline)
              const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 1.5, color: Colors.orangeAccent)),
            if (isCheckingOnline) const SizedBox(width: 8),
              Text(
                'Nhấn vào Loa ở trên để Gấu đọc mã xác nhận.',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 11, 
                  color: primaryColor.withOpacity(0.7), 
                  fontWeight: FontWeight.bold
                ),
              ),
          ],
        ),
        
        const SizedBox(height: 32),
        Text(
          'BƯỚC 2: NHẬP MÃ VÀ ĐẶT TÊN',
          style: GoogleFonts.beVietnamPro(fontSize: 11, fontWeight: FontWeight.w800, color: primaryColor.withOpacity(0.5), letterSpacing: 1.2),
        ),
        const SizedBox(height: 16),
        _glassTextField(
          label: 'Mã xác nhận 6 số (OTP)',
          hint: '• • • • • •',
          icon: Icons.key_rounded,
          isOtp: true,
          controller: codeController,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (v) {
            if (v == null || v.isEmpty) return 'Vui lòng nhập mã';
            if (v.length != 6) return 'Mã phải đủ 6 chữ số';
            return null;
          },
        ),
        const SizedBox(height: 16),
        _glassTextField(
          label: 'Tên của bé (Ví dụ: Sóc, Bê, Gấu...)',
          hint: 'Nhập tên bé để Gấu xưng hô nhé',
          icon: Icons.face_rounded,
          controller: childNameController,
          validator: (v) => (v == null || v.isEmpty) ? 'Vui lòng nhập tên bé' : null,
        ),
        const SizedBox(height: 16),
        _glassTextField(
          label: 'Đặt biệt danh cho Gấu (tùy chọn)',
          hint: 'Gấu Bông AI, SmartBear...',
          icon: Icons.edit_rounded,
          controller: nicknameController,
        ),
      ],
    );
  }

  Widget _glassTextField({
    required String label,
    required String hint,
    required IconData icon,
    bool isOtp = false,
    required TextEditingController controller,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(label, style: GoogleFonts.beVietnamPro(fontSize: 12, fontWeight: FontWeight.bold, color: textPrimary.withOpacity(0.7))),
        ),
        TextFormField(
          controller: controller,
          keyboardType: isOtp ? TextInputType.number : TextInputType.text,
          maxLength: isOtp ? 6 : null,
          textAlign: isOtp ? TextAlign.center : TextAlign.start,
          inputFormatters: inputFormatters,
          validator: validator,
          style: GoogleFonts.beVietnamPro(fontSize: isOtp ? 24 : 15, fontWeight: isOtp ? FontWeight.w900 : FontWeight.w500, letterSpacing: isOtp ? 10 : 0),
          decoration: InputDecoration(
            counterText: '',
            hintText: hint,
            prefixIcon: isOtp ? null : Icon(icon, color: primaryColor.withOpacity(0.5), size: 20),
            filled: true,
            fillColor: Colors.white.withOpacity(0.5),
            errorStyle: GoogleFonts.beVietnamPro(fontSize: 11, color: Colors.redAccent),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: primaryColor.withOpacity(0.1))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: primaryColor.withOpacity(0.05))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: primaryColor, width: 1.5)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.redAccent, width: 1)),
            focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.redAccent, width: 2)),
          ),
        ),
      ],
    );
  }
}


