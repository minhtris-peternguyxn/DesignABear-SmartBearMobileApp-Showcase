import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/api/payment_api.dart';
import '../../core/network/api_response.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _paymentApi = PaymentApi();
  bool _isLoading = false;
  final TextEditingController _voucherController = TextEditingController();

  Future<void> _buyCombo(int amount, String description) async {
    setState(() => _isLoading = true);
    try {
      // Sử dụng PaymentApi tập trung thay vì gọi http trực tiếp
      final res = await _paymentApi.createPaymentQR(
        voucherCode: _voucherController.text.trim(),
        planType: amount == 99000 ? 2 : 1, // Logic ví dụ
      );

      if (res.isSuccess && res.value != null) {
        final checkoutUrl = res.value!.checkoutUrl;
        if (await canLaunchUrl(Uri.parse(checkoutUrl))) {
          await launchUrl(Uri.parse(checkoutUrl), mode: LaunchMode.externalApplication);
        } else {
          _showError('Không thể mở trang thanh toán.');
        }
      } else {
        _showError(res.error?.description ?? 'Lỗi kết nối từ server.');
      }
    } catch (e) {
      _showError('Đã xảy ra lỗi: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  Widget _buildCreditCard(String title, String desc, int price, Color accent, String iconUrl, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
            offset: Offset(0, 5)
          )
        ],
        border: Border.all(color: accent.withOpacity(0.5), width: 1.5),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        leading: CircleAvatar(
          backgroundColor: accent.withOpacity(0.2),
          child: Icon(Icons.star_rounded, color: accent),
        ),
        title: Text(title, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(desc, style: TextStyle(color: Colors.grey[400], fontSize: 13)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: accent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          onPressed: _isLoading ? null : onTap,
          child: Text('${price / 1000}k', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        title: const Text('Cửa Hàng SmartBear', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.workspace_premium_rounded, size: 50, color: Colors.amber),
                        const SizedBox(height: 10),
                        const Text('Gói Toàn Năng', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Text('Truy cập ElevenLabs TTS, chế độ song ngữ & toán học. Không giới hạn tín dụng!', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 14)),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () => _buyCombo(99000, "Mua Gói Toàn Năng 1 Tháng"),
                            child: const Text('Nâng cấp ngay - 99.000đ/tháng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _voucherController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                       hintText: 'Nhập mã phiếu giảm giá (nếu có)',
                       hintStyle: const TextStyle(color: Colors.white54),
                       prefixIcon: const Icon(Icons.card_giftcard, color: Colors.amber),
                       filled: true,
                       fillColor: const Color(0xFF1E1E2C),
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(12),
                         borderSide: BorderSide.none,
                       )
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text('Nạp Combo Thẻ Lẻ', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 15),
                  _buildCreditCard('Combo Gấu Con', '100 Kẹo + 50 Mật Ong', 20000, Colors.pinkAccent, '', () => _buyCombo(20000, "Combo Gau Con")),
                  _buildCreditCard('Combo Mật Ngọt', '300 Kẹo + 200 Mật Ong', 50000, Colors.orangeAccent, '', () => _buyCombo(50000, "Combo Mat Ngot")),
                ],
              ),
            ),
    );
  }
}
