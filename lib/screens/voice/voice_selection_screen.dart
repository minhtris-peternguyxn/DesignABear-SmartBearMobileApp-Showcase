import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../data/api/voice_api.dart';
import '../../data/api/payment_api.dart';
import '../../core/network/api_response.dart';
import '../../data/models/response/voice_response.dart';
import '../../data/models/response/payment_response.dart';
import '../../widgets/app_toast.dart';
import 'widgets/voice_header.dart';

class VoiceSelectionScreen extends StatefulWidget {
  final bool isPicker;
  const VoiceSelectionScreen({super.key, this.isPicker = false});

  @override
  State<VoiceSelectionScreen> createState() => _VoiceSelectionScreenState();
}

class _VoiceSelectionScreenState extends State<VoiceSelectionScreen> {
  final _voiceApi = VoiceApi();
  final _paymentApi = PaymentApi();
  final _audioPlayer = AudioPlayer();
  final _textController = TextEditingController(text: "Chào bé, gấu là Lucky đây! Bé thấy giọng gấu có hay không nào?");
  
  final _scrollController = ScrollController();
  
  bool _loading = true;
  bool _isSpeaking = false;
  bool _hasHeard = false;
  List<VoiceModel> _voices = [];
  SubscriptionStatusModel? _subStatus;
  String? _selectedVoiceId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        _voiceApi.getVoiceList(),
        _paymentApi.getSubscriptionStatus(),
      ]);
      final voiceRes = results[0] as ApiResponse<List<VoiceModel>>;
      final subRes = results[1] as ApiResponse<SubscriptionStatusModel>;

      if (mounted) {
        setState(() {
          _voices = voiceRes.value ?? [];
          
          // FALLBACK TRONG TRƯỜNG HỢP API LỖI HOẶC TRỐNG
          if (_voices.isEmpty) {
            _voices = [
              VoiceModel(voiceId: "vi-VN-Neural2-A", name: "Gấu Chị A (Nữ)", provider: "GCP", description: "Giọng nữ chuẩn, vui vẻ.", isPremium: false),
              VoiceModel(voiceId: "vi-VN-Neural2-D", name: "Gấu Anh D (Nam)", provider: "GCP", description: "Giọng nam ấm áp, rõ ràng.", isPremium: false),
              VoiceModel(voiceId: "vi-VN-Wavenet-A", name: "Gấu Mẹ A (Nữ)", provider: "GCP", description: "Giọng nữ ngọt ngào, truyền cảm.", isPremium: false),
              VoiceModel(voiceId: "vi-VN-Wavenet-B", name: "Gấu Bố B (Nam)", provider: "GCP", description: "Giọng nam trầm, vững chãi.", isPremium: false),
              VoiceModel(voiceId: "TX3LPaxmHKxFfW646Sse", name: "Gấu Liam (Nam - VJP)", provider: "ElevenLabs", description: "Giọng nam truyền cảm, ấm áp nhất.", isPremium: true),
              VoiceModel(voiceId: "Lcf7eeY9feD1p95OmDAn", name: "Gấu Sarah (Nữ - VJP)", provider: "ElevenLabs", description: "Giọng nữ ngọt ngào, biểu cảm.", isPremium: true),
              VoiceModel(voiceId: "IKne3meq5pC9XdtgXx6M", name: "Gấu Charlie (Kể chuyện)", provider: "ElevenLabs", description: "Giọng nam kể chuyện cực hay.", isPremium: true),
              VoiceModel(voiceId: "MF3mGyEYCl7XYW7L696t", name: "Gấu Rachel (Nữ)", provider: "ElevenLabs", description: "Giọng nữ năng động.", isPremium: true),
            ];
          }

          _subStatus = subRes.value;
          _selectedVoiceId = _subStatus?.preferredVoiceId ?? (_voices.isNotEmpty ? _voices.first.voiceId : null);
          _loading = false;
        });

        // Tự động cuộn đến giọng đang chọn sau khi build xong
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        AppToast.show(context, 'Lỗi tải dữ liệu', type: ToastType.error);
      }
    }
  }

  void _scrollToSelected() {
    if (_selectedVoiceId == null) return;
    final index = _voices.indexWhere((v) => v.voiceId == _selectedVoiceId);
    if (index != -1) {
      // Ước tính chiều cao mỗi item là khoảng 85px + 24px tiêu đề nhóm
      final offset = (index * 85.0) + (index > 3 ? 100.0 : 0.0); 
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  Future<void> _handleSpeak() async {
    if (_selectedVoiceId == null) return;
    final voice = _voices.firstWhere((v) => v.voiceId == _selectedVoiceId);
    final text = _textController.text.trim();
    
    if (text.isEmpty) {
      AppToast.show(context, "Vui lòng nhập nội dung nói", type: ToastType.info);
      return;
    }

    final wordCount = text.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).length;
    if (wordCount > 20) {
      AppToast.show(context, "Văn bản không được quá 20 chữ", type: ToastType.error);
      return;
    }

    setState(() => _isSpeaking = true);
    try {
      final res = await _voiceApi.speak(text: text, voiceId: voice.voiceId, provider: voice.provider);
      if (res.isSuccess && res.value != null) {
        await _audioPlayer.play(UrlSource(res.value!));
        setState(() => _hasHeard = true);
      } else {
        if (mounted) AppToast.show(context, res.error?.description ?? "Lỗi phát âm", type: ToastType.error);
      }
    } finally {
      if (mounted) setState(() => _isSpeaking = false);
    }
  }

  Future<void> _handleSave() async {
    if (_selectedVoiceId == null) return;
    final voice = _voices.firstWhere((v) => v.voiceId == _selectedVoiceId);

    // Premium check
    if (voice.isPremium && _subStatus?.isPro != true) {
      AppToast.show(context, "Giọng này yêu cầu gói Premium", type: ToastType.info);
      return;
    }

    if (widget.isPicker) {
      Navigator.pop(context, voice);
      return;
    }

    setState(() => _loading = true);
    final res = await _voiceApi.updateVoicePreference(voice.provider, voice.voiceId);
    setState(() => _loading = false);

    if (res.isSuccess) {
      if (mounted) AppToast.show(context, "Đã lưu giọng ${voice.name} thành công!");
    } else {
      if (mounted) AppToast.show(context, res.error?.description ?? "Lỗi lưu cài đặt", type: ToastType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FF),
      body: SafeArea(
        child: _loading 
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                VoiceHeader(onBack: () => Navigator.pop(context)),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "STUDIO CHỌN GIỌNG",
                          style: GoogleFonts.beVietnamPro(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.grey[500], letterSpacing: 2),
                        ),
                        const SizedBox(height: 24),
                        
                        // Step 1: Text Input
                        _buildSectionTitle("1. Lucky sẽ nói gì?"),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _textController,
                          maxLines: 3,
                          maxLength: 100,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Nhập nội dung để nghe thử...",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.all(20),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Step 2: Voice List
                        _buildSectionTitle("2. Chọn giọng phù hợp"),
                        const SizedBox(height: 16),
                        
                        _buildGroupHeader("GIỌNG TIÊU CHUẨN", false),
                        ..._voices.where((v) => !v.isPremium).map((v) => _buildVoiceCard(v)),
                        
                        const SizedBox(height: 24),
                        _buildGroupHeader("GIỌNG PREMIUM VJP", true),
                        ..._voices.where((v) => v.isPremium).map((v) => _buildVoiceCard(v)),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                
                // Bottom Actions
                _buildBottomBar(),
              ],
            ),
      ),
    );
  }

  Widget _buildGroupHeader(String title, bool isPremium) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.beVietnamPro(fontSize: 12, fontWeight: FontWeight.w800, color: isPremium ? Colors.amber[800] : Colors.blue[800], letterSpacing: 1),
          ),
          if (isPremium) ...[
            const SizedBox(width: 8),
            Icon(Icons.stars_rounded, size: 16, color: Colors.amber[800]),
          ]
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.titleLarge?.color));
  }

  Widget _buildVoiceCard(VoiceModel voice) {
    final isSelected = _selectedVoiceId == voice.voiceId;
    final isLocked = voice.isPremium && _subStatus?.isPro != true;

    return GestureDetector(
      onTap: () => setState(() {
        _selectedVoiceId = voice.voiceId;
        _hasHeard = false; // Reset heard state on voice change
      }),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7C5CFC).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF7C5CFC) : Colors.transparent, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: voice.provider == "GCP" ? Colors.blue[50] : Colors.purple[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                voice.provider == "GCP" ? Icons.face_rounded : Icons.auto_awesome_rounded,
                color: voice.provider == "GCP" ? Colors.blue : Colors.purple,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(voice.name, style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(voice.description ?? "", style: GoogleFonts.beVietnamPro(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ),
            if (isLocked) 
              const Icon(Icons.lock_rounded, color: Colors.amber, size: 20)
            else if (isSelected)
              const Icon(Icons.check_circle_rounded, color: Color(0xFF7C5CFC)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _isSpeaking ? null : _handleSpeak,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                side: const BorderSide(color: Color(0xFF7C5CFC)),
              ),
              child: _isSpeaking 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Text("NGHE THỬ", style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w800, color: const Color(0xFF7C5CFC))),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: (_hasHeard && !_isSpeaking) ? _handleSave : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C5CFC),
                disabledBackgroundColor: Colors.grey[200],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Text(
                "LƯU GIỌNG NÀY", 
                style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w800, color: _hasHeard ? Colors.white : Colors.grey[400]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
