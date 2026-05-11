import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/api/safety_api.dart';
import '../../data/api/device_api.dart';
import '../../core/network/api_response.dart';
import '../../data/models/response/safety_response.dart';
import '../../data/models/response/device_model.dart';
import '../../widgets/app_toast.dart';

// Import local widgets
import 'widgets/safety_header.dart';
import 'widgets/safety_section_header.dart';
import 'widgets/banned_word_input.dart';
import 'widgets/banned_word_list.dart';
import 'widgets/device_safety_card.dart';
import 'widgets/safety_info_card.dart';
import 'widgets/safety_loading_view.dart';

class SafetySettingsScreen extends StatefulWidget {
  const SafetySettingsScreen({super.key});

  @override
  State<SafetySettingsScreen> createState() => _SafetySettingsScreenState();
}

class _SafetySettingsScreenState extends State<SafetySettingsScreen> {
  final _safetyApi = SafetyApi();
  final _deviceApi = DeviceApi();
  bool _loading = true;
  List<BannedWordModel> _bannedWords = [];
  List<DeviceModel> _devices = [];
  final _wordController = TextEditingController();
  String _selectedCategory = 'personal';

  final List<String> _categories = ['adult', 'violence', 'drug', 'weapons', 'AI_SAFETY', 'personal'];

  final Map<String, String> _categoryLabels = {
    'adult': 'Người lớn',
    'violence': 'Bạo lực',
    'drug': 'Chất kích thích',
    'weapons': 'Vũ khí',
    'AI_SAFETY': 'An toàn AI',
    'personal': 'Cá nhân',
  };

  final Map<String, Color> _categoryColors = {
    'adult': Colors.purple,
    'violence': Colors.red,
    'drug': Colors.orange,
    'weapons': Colors.brown,
    'AI_SAFETY': Colors.blue,
    'personal': Colors.teal,
  };

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        _safetyApi.getBannedWords(),
        _deviceApi.getMyDevices(),
      ]);

      final wordsRes = results[0] as ApiResponse<List<BannedWordModel>>;
      final devicesRes = results[1] as ApiResponse<List<DeviceModel>>;

      setState(() {
        _bannedWords = wordsRes.value ?? [];
        _devices = devicesRes.value ?? [];
        _loading = false;
      });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _addWord() async {
    final word = _wordController.text.trim();
    if (word.isEmpty) return;

    final res = await _safetyApi.addBannedWord(word, category: _selectedCategory);
    if (res.isSuccess) {
      _wordController.clear();
      _loadAll();
      if (mounted) AppToast.show(context, 'Đã thêm từ khóa chặn chung');
    } else {
      if (mounted) AppToast.show(context, res.error?.description ?? 'Lỗi không xác định', type: ToastType.error);
    }
  }

  Future<void> _deleteWord(int id) async {
    final res = await _safetyApi.deleteBannedWord(id);
    if (res.isSuccess) {
      _loadAll();
      if (mounted) AppToast.show(context, 'Đã gỡ bỏ từ khóa');
    }
  }

  Future<void> _updateSafetyMode(DeviceModel device, int modeId) async {
    final res = await _safetyApi.updateSafetyResponseMode(device.profileId!, modeId);
    if (res.isSuccess) {
      _loadAll();
      if (mounted) AppToast.show(context, 'Đã cập nhật chế độ phản ứng');
    }
  }

  Future<void> _addTopic(DeviceModel device, String topic) async {
    List<String> topics = List<String>.from(device.blockedTopics ?? []);
    if (!topics.contains(topic)) {
      topics.add(topic);
      final res = await _safetyApi.updateBlockedTopics(device.profileId!, topics);
      if (res.isSuccess) {
        _loadAll();
        if (mounted) AppToast.show(context, 'Đã chặn chủ đề: $topic');
      }
    }
  }

  Future<void> _removeTopic(DeviceModel device, String topic) async {
    List<String> current = List<String>.from(device.blockedTopics ?? []);
    current.remove(topic);
    final res = await _safetyApi.updateBlockedTopics(device.profileId!, current);
    if (res.isSuccess) {
      _loadAll();
      if (mounted) AppToast.show(context, 'Đã gỡ bỏ chủ đề');
    }
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
            child: _loading
              ? const SafetyLoadingView()
              : RefreshIndicator(
                  onRefresh: _loadAll,
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: SafetyHeader(onBack: () => Navigator.pop(context)),
                      ),

                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            const SafetySectionHeader(
                              title: 'Bộ lọc chung', 
                              subtitle: 'Áp dụng cho toàn bộ tài khoản gia đình.',
                              icon: Icons.shield_moon_rounded,
                              iconColor: Color(0xFF17409A),
                            ),
                            const SizedBox(height: 16),
                            BannedWordInput(
                              controller: _wordController,
                              onAdd: _addWord,
                              initialCategory: _selectedCategory,
                              categories: _categories,
                              categoryLabels: _categoryLabels,
                              categoryColors: _categoryColors,
                              onCategoryChanged: (cat) => _selectedCategory = cat,
                            ),
                            const SizedBox(height: 16),
                            BannedWordList(
                              bannedWords: _bannedWords,
                              categoryLabels: _categoryLabels,
                              categoryColors: _categoryColors,
                              onDelete: _deleteWord,
                            ),
                            const SizedBox(height: 48),
                            
                            const SafetySectionHeader(
                              title: 'Phân quyền Gấu', 
                              subtitle: 'Tùy chỉnh chặn riêng biệt cho từng thiết bị.',
                              icon: Icons.pets_rounded,
                              iconColor: Color(0xFFFF8C42),
                            ),
                            const SizedBox(height: 16),
                            if (_devices.isEmpty)
                              _buildEmptyDevicesView()
                            else
                              ..._devices.map((d) => DeviceSafetyCard(
                                device: d,
                                onUpdateMode: (mode) => _updateSafetyMode(d, mode),
                                onAddTopic: (topic) => _addTopic(d, topic),
                                onRemoveTopic: (topic) => _removeTopic(d, topic),
                              )),
                            
                            const SizedBox(height: 40),
                            const SafetyInfoCard(),
                            const SizedBox(height: 100),
                          ]),
                        ),
                      ),
                    ],
                  ),
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
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .move(begin: const Offset(0, 0), end: const Offset(80, 100), duration: 20.seconds),
        ),
        Positioned(
          bottom: 100,
          right: -100,
          child: Container(
            width: 450,
            height: 450,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF7C5CFC).withOpacity(0.05),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .move(begin: const Offset(0, 0), end: const Offset(-80, -60), duration: 25.seconds),
        ),
      ],
    );
  }

  Widget _buildEmptyDevicesView() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(Icons.pets_rounded, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Chưa có Gấu nào được kết nối.', 
            style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15, height: 1.4, color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
        ],
      ),
    );
  }
}
