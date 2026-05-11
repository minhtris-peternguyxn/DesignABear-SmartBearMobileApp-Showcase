import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/response/alarm_response.dart';
import '../../../data/models/response/media_response.dart';

class AlarmBottomSheet extends StatefulWidget {
  final AlarmModel? existingAlarm;
  final List<SongModel> songs;
  final Function(TimeOfDay, bool, String, String?, int) onSave;

  const AlarmBottomSheet({
    super.key,
    this.existingAlarm,
    required this.songs,
    required this.onSave,
  });

  @override
  State<AlarmBottomSheet> createState() => _AlarmBottomSheetState();
}

class _AlarmBottomSheetState extends State<AlarmBottomSheet> {
  late TimeOfDay _selectedTime;
  late String _wakeUpMessage;
  late bool _useVoice;
  String? _selectedAudioUrl;
  String? _selectedSongId;
  late int _repeatCount;

  @override
  void initState() {
    super.initState();
    final alarm = widget.existingAlarm;
    if (alarm != null) {
      final parts = alarm.time.split(':');
      _selectedTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } else {
      _selectedTime = TimeOfDay.now();
    }
    _wakeUpMessage = alarm?.wakeUpMessage ?? "Chào buổi sáng! Đến giờ thức dậy rồi, bé vươn vai nào!";
    _useVoice = alarm?.useVoice ?? true;
    _selectedAudioUrl = alarm?.audioUrl;
    _repeatCount = alarm?.repeatCount ?? 1;

    if (!_useVoice && _selectedAudioUrl != null) {
      try {
        final song = widget.songs.firstWhere((s) => s.audioUrl == _selectedAudioUrl || s.gcsPath == _selectedAudioUrl);
        _selectedSongId = song.id;
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 32, left: 24, right: 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 40, offset: const Offset(0, -10)),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 24),
            
            Text(
              widget.existingAlarm != null ? 'Chỉnh sửa báo thức' : 'Cài đặt báo thức mới',
              style: GoogleFonts.beVietnamPro(fontSize: 22, fontWeight: FontWeight.w900, color: const Color(0xFF1A1A2E)),
            ),
            const SizedBox(height: 32),

            // Time Picker Style
            GestureDetector(
              onTap: () async {
                final time = await showTimePicker(context: context, initialTime: _selectedTime);
                if (time != null) setState(() => _selectedTime = time);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: colorScheme.primary.withOpacity(0.1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.access_time_rounded, color: colorScheme.primary, size: 28),
                    const SizedBox(width: 16),
                    Text(
                      _selectedTime.format(context),
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: colorScheme.primary,
                        letterSpacing: -1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            _buildSectionLabel('CHẾ ĐỘ BÁO THỨC'),
            Row(
              children: [
                _buildModeTab('Giọng Gấu', Icons.record_voice_over_rounded, _useVoice, () => setState(() => _useVoice = true)),
                const SizedBox(width: 12),
                _buildModeTab('Nhạc chuông', Icons.music_note_rounded, !_useVoice, () => setState(() => _useVoice = false)),
              ],
            ),
            const SizedBox(height: 24),

            if (_useVoice) ...[
              _buildSectionLabel('LỜI NHẮC CỦA GẤU'),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: TextField(
                  maxLines: 3,
                  style: GoogleFonts.beVietnamPro(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFF1A1A2E)),
                  onChanged: (v) => _wakeUpMessage = v,
                  controller: TextEditingController(text: _wakeUpMessage)..selection = TextSelection.collapsed(offset: _wakeUpMessage.length),
                  decoration: InputDecoration(
                    hintText: 'Nhập lời nhắc...',
                    hintStyle: GoogleFonts.beVietnamPro(color: Colors.grey[400]),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ] else ...[
              _buildSectionLabel('CHỌN BÀI HÁT'),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedSongId,
                    hint: Text('Chọn bài hát...', style: GoogleFonts.beVietnamPro(color: Colors.grey[400])),
                    items: widget.songs.map((song) => DropdownMenuItem(
                      value: song.id,
                      child: Text(song.name, style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600)),
                    )).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedSongId = val;
                        final song = widget.songs.firstWhere((s) => s.id == val);
                        _selectedAudioUrl = song.audioUrl ?? song.gcsPath;
                      });
                    },
                  ),
                ),
              ),
            ],
            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(child: _buildSectionLabel('SỐ LẦN LẶP LẠI')),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    children: [
                      _buildCountBtn(Icons.remove_rounded, () {
                        if (_repeatCount > 1) setState(() => _repeatCount--);
                      }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('$_repeatCount', style: GoogleFonts.beVietnamPro(fontSize: 18, fontWeight: FontWeight.w800)),
                      ),
                      _buildCountBtn(Icons.add_rounded, () => setState(() => _repeatCount++)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => widget.onSave(_selectedTime, _useVoice, _wakeUpMessage, _selectedAudioUrl, _repeatCount),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 0,
                  shadowColor: colorScheme.primary.withOpacity(0.3),
                ),
                child: Text(
                  widget.existingAlarm != null ? 'Cập nhật báo thức' : 'Xác nhận tạo',
                  style: GoogleFonts.beVietnamPro(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        label,
        style: GoogleFonts.beVietnamPro(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Colors.grey[400],
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildModeTab(String label, IconData icon, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.grey[200]!),
            boxShadow: isSelected ? [
              BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))
            ] : [],
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.grey[400], size: 24),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 20, color: const Color(0xFF1A1A2E)),
      ),
    );
  }
}
