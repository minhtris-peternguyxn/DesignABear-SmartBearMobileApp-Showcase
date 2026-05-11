import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/api/alarm_api.dart';
import '../../data/api/media_api.dart';
import '../../data/models/response/alarm_response.dart';
import '../../data/models/response/media_response.dart';
import '../../data/models/request/common_requests.dart';
import '../../widgets/app_toast.dart';
import 'widgets/alarm_header.dart';
import 'widgets/alarm_skeleton.dart';
import 'widgets/alarm_card.dart';
import 'widgets/alarm_empty_view.dart';
import 'widgets/alarm_bottom_sheet.dart';

class AlarmScreen extends StatefulWidget {
  final String deviceId;

  const AlarmScreen({super.key, required this.deviceId});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final _alarmApi = AlarmApi();
  final _mediaApi = MediaApi();
  bool _isLoading = true;
  List<AlarmModel> _alarms = [];
  List<SongModel> _songs = [];

  @override
  void initState() {
    super.initState();
    _fetchAlarms();
    _fetchSongs();
  }

  Future<void> _fetchSongs() async {
    try {
      final response = await _mediaApi.getSongs();
      if (response.isSuccess) {
        if (mounted) setState(() => _songs = response.value ?? []);
      }
    } catch (_) {}
  }

  Future<void> _fetchAlarms() async {
    setState(() => _isLoading = true);
    try {
      final response = await _alarmApi.getAlarms();
      if (response.isSuccess) {
        final alarms = response.value ?? [];
        if (mounted) {
          setState(() {
            _alarms = alarms.where((a) => a.deviceId == widget.deviceId).toList();
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() => _isLoading = false);
          AppToast.show(context, 'Lỗi tải báo thức: ${response.error?.description}', type: ToastType.error);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        AppToast.show(context, 'Lỗi kết nối: $e', type: ToastType.error);
      }
    }
  }

  Future<void> _toggleAlarm(bool val, String alarmId) async {
    try {
      final response = await _alarmApi.toggleAlarm(alarmId);
      if (!response.isSuccess && mounted) {
        AppToast.show(context, 'Lỗi: ${response.error?.description}', type: ToastType.error);
      }
      _fetchAlarms();
    } catch (e) {
      if (mounted) AppToast.show(context, 'Lỗi: $e', type: ToastType.error);
    }
  }

  Future<void> _deleteAlarm(String alarmId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text('Xóa báo thức?', 
          style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w900, color: const Color(0xFF1A1A2E))),
        content: Text('Bạn có chắc chắn muốn xóa bản cài đặt báo thức này không?',
          style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey[600], height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('HỦY', style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w800, color: Colors.grey[400])),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('XÓA NGAY', style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w800, color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final response = await _alarmApi.deleteAlarm(alarmId);
      if (response.isSuccess) {
        AppToast.show(context, 'Đã xóa báo thức', type: ToastType.success);
      } else {
        if (mounted) AppToast.show(context, 'Lỗi: ${response.error?.description}', type: ToastType.error);
      }
      _fetchAlarms();
    } catch (e) {
      if (mounted) AppToast.show(context, 'Lỗi kết nối: $e', type: ToastType.error);
    }
  }

  void _showAlarmSheet({AlarmModel? alarm}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AlarmBottomSheet(
        existingAlarm: alarm,
        songs: _songs,
        onSave: (time, useVoice, msg, audioUrl, repeat) {
          Navigator.pop(ctx);
          if (alarm != null) {
            _handleUpdateAlarm(alarm.alarmId, time, useVoice, msg, audioUrl, repeat);
          } else {
            _handleCreateAlarm(time, useVoice, msg, audioUrl, repeat);
          }
        },
      ),
    );
  }

  Future<void> _handleCreateAlarm(TimeOfDay time, bool useVoice, String msg, String? audioUrl, int repeat) async {
    setState(() => _isLoading = true);
    try {
      final res = await _alarmApi.createAlarm(AlarmRequest(
        deviceId: widget.deviceId,
        hour: time.hour,
        minute: time.minute,
        isEnabled: true,
        useVoice: useVoice,
        wakeUpMessage: msg,
        audioUrl: audioUrl,
        repeatCount: repeat,
        repeatMode: 'Count',
      ));
      if (res.isSuccess) {
        AppToast.show(context, 'Đã tạo báo thức mới');
        _fetchAlarms();
      } else {
        setState(() => _isLoading = false);
        if (mounted) AppToast.show(context, 'Lỗi: ${res.error?.description}', type: ToastType.error);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      if (mounted) AppToast.show(context, 'Lỗi kết nối: $e', type: ToastType.error);
    }
  }

  Future<void> _handleUpdateAlarm(String alarmId, TimeOfDay time, bool useVoice, String msg, String? audioUrl, int repeat) async {
    setState(() => _isLoading = true);
    try {
      final res = await _alarmApi.updateAlarm(alarmId, AlarmRequest(
        deviceId: widget.deviceId,
        hour: time.hour,
        minute: time.minute,
        isEnabled: true,
        useVoice: useVoice,
        wakeUpMessage: msg,
        audioUrl: audioUrl,
        repeatCount: repeat,
        repeatMode: 'Count',
      ));
      if (res.isSuccess) {
        AppToast.show(context, 'Đã cập nhật báo thức');
        _fetchAlarms();
      } else {
        if (mounted) setState(() => _isLoading = false);
        if (mounted) AppToast.show(context, 'Lỗi: ${res.error?.description}', type: ToastType.error);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      if (mounted) AppToast.show(context, 'Lỗi kết nối: $e', type: ToastType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: Stack(
        children: [
          _buildAuraBlobs(),
          SafeArea(
            child: Column(
              children: [
                AlarmHeader(
                  onBack: () => Navigator.pop(context),
                  onAdd: () => _showAlarmSheet(),
                ),
                Expanded(
                  child: _isLoading 
                    ? const AlarmSkeleton()
                    : _alarms.isEmpty
                      ? AlarmEmptyView(onAdd: () => _showAlarmSheet())
                      : RefreshIndicator(
                          onRefresh: _fetchAlarms,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            itemCount: _alarms.length,
                            itemBuilder: (context, index) {
                              final alarm = _alarms[index];
                              return AlarmCard(
                                alarm: alarm,
                                onToggle: (val) => _toggleAlarm(val, alarm.alarmId),
                                onDelete: () => _deleteAlarm(alarm.alarmId),
                                onEdit: () => _showAlarmSheet(alarm: alarm),
                              );
                            },
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

  Widget _buildAuraBlobs() {
    return Stack(
      children: [
        Positioned(
          top: -150,
          right: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor.withOpacity(0.06),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .move(begin: const Offset(0, 0), end: const Offset(-50, 100), duration: 20.seconds),
        ),
        Positioned(
          bottom: 100,
          left: -150,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFF8C42).withOpacity(0.04),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .move(begin: const Offset(0, 0), end: const Offset(100, -50), duration: 25.seconds),
        ),
      ],
    );
  }
}
