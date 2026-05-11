import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../data/api/voice_api.dart';
import '../../core/network/api_response.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/models/response/voice_response.dart';

class VoiceDemoScreen extends StatefulWidget {
  const VoiceDemoScreen({super.key});

  @override
  State<VoiceDemoScreen> createState() => _VoiceDemoScreenState();
}

class _VoiceDemoScreenState extends State<VoiceDemoScreen> {
  final TextEditingController _textController = TextEditingController(
    text: "Chào bé, gấu là Lucky đây! Đây là giọng đọc của Lucky này, bé nghe có thấy vui nhộn không nào?",
  );
  final VoiceApi _voiceApi = VoiceApi();
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  String _selectedProvider = "GCP";
  String? _selectedVoiceId;
  bool _isLoading = false;
  bool _isInitLoading = true;
  List<VoiceModel> _voiceList = [];

  @override
  void initState() {
    super.initState();
    _loadVoices();
  }

  Future<void> _loadVoices() async {
    try {
      final res = await _voiceApi.getVoiceList();
      if (mounted) {
        setState(() {
          _voiceList = res.value ?? [];
          if (_voiceList.isNotEmpty) {
            _selectedProvider = _voiceList.first.provider;
            _selectedVoiceId = _voiceList.first.voiceId;
          }
          _isInitLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isInitLoading = false);
      }
    }
  }

  List<String> get _providers {
    if (_voiceList.isEmpty) return ["GCP", "ElevenLabs"];
    return _voiceList.map((v) => v.provider).toSet().toList();
  }

  List<VoiceModel> _getVoicesForProvider(String provider) {
    if (_voiceList.isEmpty) return [];
    return _voiceList.where((v) => v.provider == provider).toList();
  }

  @override
  void dispose() {
    _textController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _handleSpeak() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final wordCount = text.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).length;
    if (wordCount > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Văn bản không được quá 20 chữ")),
      );
      return;
    }
    if (_selectedVoiceId == null) return;

    setState(() => _isLoading = true);
    try {
      final response = await _voiceApi.speak(
        text: text,
        voiceId: _selectedVoiceId!,
        provider: _selectedProvider,
      );

      if (response.isSuccess && response.value != null) {
        await _audioPlayer.play(UrlSource(response.value!));
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.error?.description ?? "Lỗi phát âm")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text("Lucky Speak", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: const Icon(Icons.mic_rounded, size: 60, color: Color(0xFF7C5CFC)),
              ).animate(onPlay: (controller) => controller.repeat()).shimmer(duration: 2.seconds),
            ),
            const SizedBox(height: 32),
            const Text(
              "Nội dung muốn Lucky nói",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _textController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Nhập văn bản tại đây...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(20),
              ),
            ),
            const SizedBox(height: 24),
            _isInitLoading 
              ? const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator()))
              : Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: "Nhà cung cấp",
                    value: _selectedProvider,
                    items: _providers,
                    onChanged: (val) {
                      if (val == null) return;
                      setState(() {
                        _selectedProvider = val;
                        final available = _getVoicesForProvider(val);
                        if (available.isNotEmpty) {
                          _selectedVoiceId = available.first.voiceId;
                        } else {
                          _selectedVoiceId = null;
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _selectedVoiceId == null 
                    ? const SizedBox() 
                    : _buildDropdown(
                    label: "Giọng nói",
                    value: _selectedVoiceId!,
                    items: _getVoicesForProvider(_selectedProvider).map((v) => v.voiceId).toList(),
                    itemLabels: _getVoicesForProvider(_selectedProvider).map((v) => v.name).toList(),
                    onChanged: (val) => setState(() => _selectedVoiceId = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSpeak,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C5CFC),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 8,
                  shadowColor: const Color(0xFF7C5CFC).withOpacity(0.4),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.play_arrow_rounded, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "NGHE GIỌNG LUCKY",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    List<String>? itemLabels,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: List.generate(items.length, (index) {
                return DropdownMenuItem(
                  value: items[index],
                  child: Text(itemLabels != null ? itemLabels[index] : items[index], style: const TextStyle(fontSize: 13)),
                );
              }),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
