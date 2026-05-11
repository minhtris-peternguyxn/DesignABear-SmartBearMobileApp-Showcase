import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/api/history_api.dart';
import '../../data/models/response/history_response.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../widgets/app_toast.dart';

// Import local widgets
import 'widgets/chat_bubble.dart';

class SessionDetailScreen extends StatefulWidget {
  final String sessionId;

  const SessionDetailScreen({super.key, required this.sessionId});

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  final _historyApi = HistoryApi();
  bool _loading = true;
  SessionDetailModel? _session;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    setState(() => _loading = true);
    final res = await _historyApi.getSessionDetails(widget.sessionId);
    if (mounted) {
      setState(() {
        _session = res.value;
        _loading = false;
      });
    }
  }

  Future<void> _deleteSession() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text('Xóa lịch sử', style: GoogleFonts.fredoka(fontWeight: FontWeight.w700)),
        content: Text('Bạn có chắc muốn xóa phiên trò chuyện này không?', style: GoogleFonts.inter()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false), 
            child: Text('HỦY', style: GoogleFonts.inter(fontWeight: FontWeight.w800, color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('XÓA NGAY', style: GoogleFonts.inter(fontWeight: FontWeight.w800, color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final res = await _historyApi.deleteSession(widget.sessionId);
      if (res.isSuccess && mounted) {
        AppToast.show(context, 'Đã xóa phiên trò chuyện');
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Aura Background
          Container(color: const Color(0xFFF4F7FF)),
          _buildAuraBlobs(),

          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 120, sigmaY: 120),
              child: Container(color: Colors.transparent),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                if (_session != null) _buildSummaryBar(),
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator()) // Could use a skeleton list here too
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                          physics: const BouncingScrollPhysics(),
                          itemCount: _session?.interactions.length ?? 0,
                          itemBuilder: (context, index) {
                            final item = _session!.interactions[index];
                            return ChatBubble(item: item)
                                .animate()
                                .fadeIn(delay: (100 * index).ms)
                                .slideX(begin: index % 2 == 0 ? 0.1 : -0.1);
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5)),
                ],
              ),
              child: const Icon(Icons.arrow_back_rounded, size: 22, color: Color(0xFF1A1A2E)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              _session?.title ?? 'Chi tiết trò chuyện',
              style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFF1A1A2E)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
            onPressed: _deleteSession,
          )
        ],
      ),
    );
  }

  Widget _buildSummaryBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome_rounded, size: 16, color: Color(0xFF7C5CFC)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _session?.summary ?? 'Gấu và bé đang trò chuyện vui vẻ...',
              style: GoogleFonts.inter(color: const Color(0xFF1A1A2E).withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.w500, height: 1.4),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.2);
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
              shape: BoxShape.circle,
              color: const Color(0xFF4ECDC4).withOpacity(0.06),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .move(begin: const Offset(0, 0), end: const Offset(80, 100), duration: 25.seconds),
        ),
        Positioned(
          bottom: 100,
          right: -100,
          child: Container(
            width: 450,
            height: 450,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF7C5CFC).withOpacity(0.04),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .move(begin: const Offset(0, 0), end: const Offset(-100, -150), duration: 20.seconds),
        ),
      ],
    );
  }
}
