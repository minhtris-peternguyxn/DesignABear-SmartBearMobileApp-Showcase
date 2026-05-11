import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../data/api/device_api.dart';
import '../../data/api/voice_api.dart';
import '../voice/voice_selection_screen.dart';
import '../safety/safety_settings_screen.dart';
import '../alarm/alarm_screen.dart';
import '../../widgets/app_toast.dart';
import '../../data/models/response/voice_response.dart';

// Import local widgets
import 'widgets/profile_header.dart';
import 'widgets/profile_avatar_section.dart';
import 'widgets/profile_input_card.dart';
import 'widgets/profile_action_card.dart';
import 'widgets/premium_profile_card.dart';
import 'widgets/premium_alarm_card.dart';
import 'widgets/voice_lab_card.dart';
import 'widgets/profile_skeleton_view.dart';

class BearProfileScreen extends StatefulWidget {
  final Map<String, dynamic> device;

  const BearProfileScreen({super.key, required this.device});

  @override
  State<BearProfileScreen> createState() => _BearProfileScreenState();
}

class _BearProfileScreenState extends State<BearProfileScreen> {
  final _deviceApi = DeviceApi();
  final _voiceApi = VoiceApi();
  final _audioPlayer = AudioPlayer();
  
  late TextEditingController _nameController;
  late TextEditingController _nicknameController;
  late TextEditingController _personalityDescController;
  late TextEditingController _pretendMessageController;
  late TextEditingController _warningMessageController;

  int _age = 5;
  String _gender = 'Chưa xác định';
  String _honorific = 'Bạn';
  String _personality = 'Vui vẻ';
  String _voiceId = '';
  String _voiceProvider = 'GCP';
  String _voiceName = 'Giọng mặc định';
  int _safetyResponseMode = 2;
  List<String> _blockedTopics = [];
  int _creativityLevel = 3;
  int _emotionLevel = 3;
  int _energyLevel = 3;
  int _complexityLevel = 3;
  String _profileImageUrl = '';

  bool _isLoading = false;
  bool _isMainLoading = true;
  bool _isSpeaking = false;
  DateTime _lastLiveUpdate = DateTime.now();

  final List<String> _defaultAvatars = [
    'https://api.dicebear.com/7.x/bottts/png?seed=Lucky&backgroundColor=b6e3f4',
    'https://api.dicebear.com/7.x/bottts/png?seed=Bear1&backgroundColor=ffdfbf',
    'https://api.dicebear.com/7.x/bottts/png?seed=Smarty&backgroundColor=d1d4f9',
    'https://api.dicebear.com/7.x/bottts/png?seed=Buddy&backgroundColor=ffd5dc',
    'https://api.dicebear.com/7.x/bottts/png?seed=CoolBear&backgroundColor=c0aede',
  ];

  // Legacy fallback for known IDs while API is loading
  final Map<String, String> _voiceNameMap = {
    'vi-VN-Neural2-A': 'Gấu Chị A (Nữ)',
    'vi-VN-Neural2-D': 'Gấu Anh D (Nam)',
    'vi-VN-Wavenet-A': 'Gấu Mẹ A (Nữ)',
    'vi-VN-Wavenet-B': 'Gấu Bố B (Nam)',
    'TX3LPaxmHKxFfW646Sse': 'Gấu Liam (Nam - VJP)',
    'Lcf7eeY9feD1p95OmDAn': 'Gấu Sarah (Nữ - VJP)',
    'IKne3meq5pC9XdtgXx6M': 'Gấu Charlie (Kể chuyện)',
    'MF3mGyEYCl7XYW7L696t': 'Gấu Rachel (Nữ)',
    'foH7s9fX31wFFH2yqrFa': 'Gấu Liam (Nam - Cũ)',
    'UsgbMVmY3U59ijwK5mdh': 'Gấu Sarah (Nữ - Cũ)',
    '6adFm46eyy74snVn6YrT': 'Gấu Charlie (Kể chuyện - Cũ)',
    'aN7cv9yXNrfIR87bDmyD': 'Gấu Adam (Nam - Cũ)',
    'EXAVITQu4vr4xnSDxMaL': 'Gấu Bella (Nữ - Cũ)',
  };

  @override
  void initState() {
    super.initState();
    _initData();
    _fetchVoiceName();
  }

  Future<void> _fetchVoiceName() async {
    try {
      final res = await _voiceApi.getVoiceList();
      if (res.isSuccess && res.value != null && mounted) {
        final voice = res.value!.cast<VoiceModel?>().firstWhere(
          (v) => v?.voiceId == _voiceId, 
          orElse: () => null
        );
        if (voice != null) {
          setState(() {
            _voiceName = voice.name;
          });
        }
      }
    } catch (_) {}
  }

  void _initData() {
    final d = widget.device;
    // Support both camelCase (JSON default) and PascalCase (C# default) just in case
    _nameController = TextEditingController(text: d['profileName'] ?? d['ProfileName'] ?? 'Bạn Nhỏ');
    _nicknameController = TextEditingController(text: d['bearName'] ?? d['BearName'] ?? d['nickname'] ?? d['Nickname'] ?? 'Gấu SmartBear');
    _age = (d['age'] ?? d['Age'] ?? 5).toInt().clamp(1, 15);
    _gender = d['gender'] ?? d['Gender'] ?? 'Chưa xác định';
    if (!['Trai', 'Gái', 'Chưa xác định'].contains(_gender)) _gender = 'Chưa xác định';
    
    _honorific = d['honorific'] ?? d['Honorific'] ?? 'Bạn';
    if (!['Bạn', 'Tớ', 'Anh', 'Chị', 'Gấu', 'Minh'].contains(_honorific)) _honorific = 'Bạn';
    _personality = d['personality'] ?? d['Personality'] ?? 'Vui vẻ';
    if (!['Vui vẻ', 'Học thuật', 'Trầm tính', 'Hài hước', 'Nghiêm túc'].contains(_personality)) _personality = 'Vui vẻ';
    _personalityDescController = TextEditingController(text: d['personalityDescription'] ?? d['PersonalityDescription'] ?? '');
    _voiceId = d['preferredVoiceId'] ?? d['PreferredVoiceId'] ?? 'vi-VN-Neural2-A';
    _voiceProvider = d['preferredTtsProvider'] ?? d['PreferredTtsProvider'] ?? 'GCP';
    _voiceName = _voiceNameMap[_voiceId] ?? 'Giọng tuỳ chỉnh';
    _safetyResponseMode = d['safetyResponseMode'] ?? d['SafetyResponseMode'] ?? 2;
    _blockedTopics = List<String>.from(d['blockedTopics'] ?? d['BlockedTopics'] ?? []);
    _pretendMessageController = TextEditingController(text: d['safetyPretendMessage'] ?? d['SafetyPretendMessage'] ?? 'Hả? Bé nói gì gấu nghe không rõ nhỉ? Bé nói lại được không?');
    _warningMessageController = TextEditingController(text: d['safetyWarningMessage'] ?? d['SafetyWarningMessage'] ?? 'Bé ơi, mình nói chuyện khác vui hơn nhé!');
    _creativityLevel = (d['creativityLevel'] ?? d['CreativityLevel'] ?? 3).toInt().clamp(1, 5);
    _emotionLevel = (d['emotionLevel'] ?? d['EmotionLevel'] ?? 3).toInt().clamp(1, 5);
    _energyLevel = (d['energyLevel'] ?? d['EnergyLevel'] ?? 3).toInt().clamp(1, 5);
    _complexityLevel = (d['complexityLevel'] ?? d['ComplexityLevel'] ?? 3).toInt().clamp(1, 5);
    _profileImageUrl = d['profileImageUrl'] ?? d['ProfileImageUrl'] ?? '';

    // Simulate short loading for skeleton
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _isMainLoading = false);
    });
  }


  Future<void> _handleSave() async {
    setState(() => _isLoading = true);
    try {
      final profileId = widget.device['profileId'];
      final body = {
        'name': _nameController.text.trim(),
        'bearName': _nicknameController.text.trim(),
        'age': _age,
        'gender': _gender,
        'honorific': _honorific,
        'personality': _personality,
        'personalityDescription': _personalityDescController.text.trim(),
        'preferredVoiceId': _voiceId,
        'preferredTtsProvider': _voiceProvider,
        'safetyResponseMode': _safetyResponseMode,
        'blockedTopics': _blockedTopics,
        'safetyPretendMessage': _pretendMessageController.text.trim(),
        'safetyWarningMessage': _warningMessageController.text.trim(),
        'creativityLevel': _creativityLevel,
        'emotionLevel': _emotionLevel,
        'energyLevel': _energyLevel,
        'complexityLevel': _complexityLevel,
        'profileImageUrl': _profileImageUrl,
      };

      final res = profileId != null 
          ? await _deviceApi.updateProfile(profileId, body)
          : await _deviceApi.createProfile(widget.device['deviceId'], body);

      if (mounted) {
        setState(() => _isLoading = false);
        debugPrint('Profile update result: ${res.isSuccess}, error: ${res.error?.description}');
        
        if (res.isSuccess) {
          AppToast.show(context, 'Đã lưu cấu hình bạn Gấu!');
          Navigator.pop(context, true);
        } else {
          AppToast.show(context, 'Lỗi: ${res.error?.description}', type: ToastType.error);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        AppToast.show(context, 'Lỗi kết nối: $e', type: ToastType.error);
      }
    }
  }

  Future<void> _handleUnpair() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text('Huỷ ghép nối', style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, color: Colors.redAccent)),
        content: Text(
          'Sau khi huỷ ghép nối, toàn bộ cấu hình tính cách và lịch sử của bé sẽ bị xoá vĩnh viễn. Bạn có chắc không?',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('HỦY', style: GoogleFonts.inter(fontWeight: FontWeight.w800, color: Colors.grey))),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            child: Text('XOÁ VĨNH VIỄN', style: GoogleFonts.inter(fontWeight: FontWeight.w800, color: Colors.redAccent))
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      final res = await _deviceApi.unpairDevice(widget.device['deviceId']);
      if (mounted) {
        if (res.isSuccess) {
          AppToast.show(context, 'Đã huỷ ghép nối thành công');
          Navigator.pop(context, true);
        } else {
          AppToast.show(context, 'Lỗi: ${res.error?.description}', type: ToastType.error);
        }
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        AppToast.show(context, 'Lỗi kết nối: $e', type: ToastType.error);
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _nameController.dispose();
    _nicknameController.dispose();
    _personalityDescController.dispose();
    _pretendMessageController.dispose();
    _warningMessageController.dispose();
    super.dispose();
  }

  Future<void> _handleVoiceDemo() async {
    if (_voiceId.isEmpty) return;
    
    setState(() => _isSpeaking = true);
    try {
      final res = await _voiceApi.speak(
        text: "Chào bé, gấu là Lucky đây! Bé thấy giọng gấu có hay không nào?",
        voiceId: _voiceId,
        provider: _voiceProvider,
      );
      
      if (res.isSuccess && res.value != null) {
        await _audioPlayer.play(UrlSource(res.value!));
      } else {
        if (mounted) AppToast.show(context, res.error?.description ?? "Lỗi phát âm", type: ToastType.error);
      }
    } catch (e) {
      if (mounted) AppToast.show(context, "Lỗi: $e", type: ToastType.error);
    } finally {
      if (mounted) setState(() => _isSpeaking = false);
    }
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 24),
            Text(
              'CHỌN NGOẠI HÌNH GẤU',
              style: GoogleFonts.fredoka(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A2E),
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _defaultAvatars.length,
                separatorBuilder: (_, __) => const SizedBox(width: 20),
                itemBuilder: (context, index) {
                  final url = _defaultAvatars[index];
                  final isSelected = _profileImageUrl == url;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _profileImageUrl = url);
                      Navigator.pop(ctx);
                    },
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: 300.ms,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? const Color(0xFF7C5CFC) : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))
                              ],
                            ),
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(height: 4),
                          const Icon(Icons.check_circle, size: 14, color: Color(0xFF7C5CFC)),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showAddTopicDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Thêm chủ đề chặn', style: GoogleFonts.fredoka(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Nhập tên chủ đề (VD: Bạo lực...)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('HỦY')),
          TextButton(
            onPressed: () {
              final val = controller.text.trim();
              if (val.isNotEmpty) {
                setState(() => _blockedTopics.add(val));
              }
              Navigator.pop(ctx);
            }, 
            child: const Text('THÊM')
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Aura Background
          Container(color: Theme.of(context).scaffoldBackgroundColor),
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
              ? const ProfileSkeletonView()
              : Column(
                  children: [
                    ProfileHeader(
                      onBack: () => Navigator.pop(context),
                      onSave: _handleSave,
                      isLoading: _isLoading,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileAvatarSection(
                              serialNumber: widget.device['serialNumber'] ?? 'S/N: Unknown',
                              profileImageUrl: _profileImageUrl,
                              onTap: _showAvatarPicker,
                            ),
                            const SizedBox(height: 48),

                            PremiumProfileCard(
                              title: 'THÔNG TIN CƠ BẢN',
                              children: [
                                ProfileInputCard(
                                  flat: true,
                                  icon: Icons.face_rounded,
                                  label: 'Tên của bé (Dùng để Gấu xưng hô)',
                                  child: TextField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(border: InputBorder.none, hintText: 'Nhập tên bé...', isDense: true),
                                    style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w700, fontSize: 18, color: const Color(0xFF17409A)),
                                  ),
                                ),
                                ProfileInputCard(
                                  flat: true,
                                  icon: Icons.pets_rounded,
                                  label: 'Biệt danh của Gấu (VD: Gấu Trắng, Lucky...)',
                                  child: TextField(
                                    controller: _nicknameController,
                                    decoration: const InputDecoration(border: InputBorder.none, hintText: 'Nhập biệt danh gấu...', isDense: true),
                                    style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w700, fontSize: 16, color: Theme.of(context).textTheme.bodyLarge?.color),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ProfileInputCard(
                                        flat: true,
                                        icon: Icons.cake_rounded,
                                        label: 'Độ tuổi',
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<int>(
                                            value: _age,
                                            isExpanded: true,
                                            icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                                            items: List.generate(15, (i) => i + 1).map((age) => 
                                              DropdownMenuItem(value: age, child: Text('$age tuổi', style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600)))).toList(),
                                            onChanged: (v) => setState(() => _age = v ?? _age),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(width: 1, height: 40, color: Colors.white.withOpacity(0.5)),
                                    Expanded(
                                      child: ProfileInputCard(
                                        flat: true,
                                        icon: Icons.person_rounded,
                                        label: 'Giới tính',
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: _gender,
                                            isExpanded: true,
                                            icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                                            items: ['Trai', 'Gái', 'Chưa xác định'].map((g) => 
                                              DropdownMenuItem(value: g, child: Text(g, style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600)))).toList(),
                                            onChanged: (v) => setState(() => _gender = v ?? _gender),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ProfileInputCard(
                                  flat: true,
                                  icon: Icons.record_voice_over_rounded,
                                  label: 'Gấu xưng hô với bé là',
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _honorific,
                                      isExpanded: true,
                                      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                                      items: ['Bạn', 'Tớ', 'Anh', 'Chị', 'Gấu', 'Minh'].map((h) => 
                                        DropdownMenuItem(value: h, child: Text(h, style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600)))).toList(),
                                      onChanged: (v) => setState(() => _honorific = v ?? _honorific),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),
                            PremiumProfileCard(
                              title: 'PERSONALITY LAB (beta)',
                              children: [
                                _buildLabSlider(
                                  label: 'Mức độ Sáng tạo',
                                  value: _creativityLevel,
                                  icon: Icons.auto_awesome_rounded,
                                  leftLabel: 'Logic/Thực tế',
                                  rightLabel: 'Bay bổng/Tưởng tượng',
                                  onChanged: (v) => setState(() => _creativityLevel = v.toInt()),
                                ),
                                _buildLabSlider(
                                  label: 'Mức độ Biểu cảm',
                                  value: _emotionLevel,
                                  icon: Icons.favorite_rounded,
                                  leftLabel: 'Trung tính',
                                  rightLabel: 'Nhiều cảm xúc',
                                  onChanged: (v) => setState(() => _emotionLevel = v.toInt()),
                                ),
                                _buildLabSlider(
                                  label: 'Năng lượng giọng nói',
                                  value: _energyLevel,
                                  icon: Icons.bolt_rounded,
                                  leftLabel: 'Nhẹ nhàng/Điềm tĩnh',
                                  rightLabel: 'Nhiều năng lượng',
                                  onChanged: (v) => setState(() => _energyLevel = v.toInt()),
                                ),
                                _buildLabSlider(
                                  label: 'Độ phức tạp ngôn từ',
                                  value: _complexityLevel,
                                  icon: Icons.menu_book_rounded,
                                  leftLabel: 'Dễ hiểu/Đơn giản',
                                  rightLabel: 'Hàn lâm/Phức tạp',
                                  onChanged: (v) => setState(() => _complexityLevel = v.toInt()),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),
                            PremiumAlarmCard(
                              subtitle: 'Cài đặt báo thức bằng giọng Gấu',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => AlarmScreen(deviceId: widget.device['deviceId'])),
                              ),
                            ),
                            const SizedBox(height: 16),
                            VoiceLabCard(
                              currentVoiceName: _voiceName,
                              isSpeaking: _isSpeaking,
                              onDemoTap: _handleVoiceDemo,
                              onSelectTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const VoiceSelectionScreen(isPicker: true)),
                                );
                                if (result != null && result is VoiceModel) {
                                  setState(() {
                                    _voiceId = result.voiceId;
                                    _voiceProvider = result.provider;
                                    _voiceName = result.name;
                                  });
                                }
                              },
                            ),

                            const SizedBox(height: 32),
                            PremiumProfileCard(
                              title: 'TÍNH CÁCH AI',
                              children: [
                                ProfileInputCard(
                                  flat: true,
                                  icon: Icons.psychology_rounded,
                                  label: 'Tính cách chủ đạo',
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _personality,
                                      isExpanded: true,
                                      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                                      items: ['Vui vẻ', 'Học thuật', 'Trầm tính', 'Hài hước', 'Nghiêm túc'].map((p) => 
                                        DropdownMenuItem(value: p, child: Text(p, style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600)))).toList(),
                                      onChanged: (v) => setState(() => _personality = v ?? _personality),
                                    ),
                                  ),
                                ),
                                ProfileInputCard(
                                  flat: true,
                                  icon: Icons.description_rounded,
                                  label: 'Mô tả thêm tính cách (Lời nhắc AI)',
                                  child: TextField(
                                    controller: _personalityDescController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      border: InputBorder.none, 
                                      hintText: 'VD: Gấu rất thích kể chuyện cười...',
                                      hintStyle: GoogleFonts.beVietnamPro(fontSize: 12, color: Colors.grey[400]),
                                      isDense: true,
                                    ),
                                    style: GoogleFonts.beVietnamPro(fontSize: 14, height: 1.5, fontWeight: FontWeight.w500, color: Theme.of(context).textTheme.bodyMedium?.color),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 60),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.link_off_rounded, size: 20),
                                label: Text('HUỶ GHÉP NỐI THIẾT BỊ', style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  foregroundColor: Colors.redAccent,
                                  side: BorderSide(color: Colors.redAccent.withOpacity(0.2)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  backgroundColor: Colors.redAccent.withOpacity(0.04),
                                ),
                                onPressed: _isLoading ? null : _handleUnpair,
                              ),
                            ).animate().fadeIn(delay: 500.ms),

                            const SizedBox(height: 100),
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

  Widget _buildLabSlider({
    required String label,
    required int value,
    required IconData icon,
    required String leftLabel,
    required String rightLabel,
    required ValueChanged<double> onChanged,
  }) {
    final activeColor = const Color(0xFF7C5CFC);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: activeColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: activeColor),
              ),
              const SizedBox(width: 12),
              Text(
                label, 
                style: GoogleFonts.beVietnamPro(
                  fontWeight: FontWeight.w800, 
                  fontSize: 14, 
                  color: const Color(0xFF1E293B),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: activeColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
                  ],
                ),
                child: Text(
                  'Mức $value', 
                  style: GoogleFonts.fredoka(
                    fontWeight: FontWeight.w700, 
                    fontSize: 11, 
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 10,
              activeTrackColor: activeColor,
              inactiveTrackColor: activeColor.withOpacity(0.1),
              thumbColor: Colors.white,
              overlayColor: activeColor.withOpacity(0.1),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12, elevation: 6),
              trackShape: const RoundedRectSliderTrackShape(),
            ),
            child: Slider(
              value: value.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              onChanged: onChanged,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(leftLabel, style: GoogleFonts.beVietnamPro(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w600)),
                Text(rightLabel, style: GoogleFonts.beVietnamPro(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w600)),
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
          left: -100,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF7C5CFC).withOpacity(0.04),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .move(begin: const Offset(0, 0), end: const Offset(120, 180), duration: 25.seconds),
        ),
        Positioned(
          bottom: 100,
          right: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFF8C42).withOpacity(0.05),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .move(begin: const Offset(0, 0), end: const Offset(-80, -120), duration: 20.seconds),
        ),
      ],
    );
  }
}
