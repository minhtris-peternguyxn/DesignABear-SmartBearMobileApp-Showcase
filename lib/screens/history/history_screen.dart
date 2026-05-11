import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../data/api/history_api.dart';
import '../../data/models/response/history_response.dart';
import 'session_detail_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Import local widgets
import 'widgets/history_header.dart';
import 'widgets/history_empty_view.dart';
import 'widgets/session_card.dart';
import 'widgets/history_loading_view.dart';

class HistoryScreen extends StatefulWidget {
  final Map<String, dynamic> profile;

  const HistoryScreen({super.key, required this.profile});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _historyApi = HistoryApi();
  bool _loading = true;
  List<ChatSessionModel> _sessions = [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    setState(() => _loading = true);
    final res = await _historyApi.getChatSessions(widget.profile['id']);
    if (mounted) {
      setState(() {
        _sessions = res.value ?? [];
        _loading = false;
      });
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
                HistoryHeader(
                  profileName: widget.profile['name'] ?? 'Bạn Gấu',
                  onBack: () => Navigator.pop(context),
                  onRefresh: _loadSessions,
                ),
                Expanded(
                  child: _loading
                      ? const HistoryLoadingView()
                      : _sessions.isEmpty
                          ? const HistoryEmptyView()
                          : RefreshIndicator(
                              onRefresh: _loadSessions,
                              child: ListView.builder(
                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                                physics: const BouncingScrollPhysics(),
                                itemCount: _sessions.length,
                                itemBuilder: (context, index) {
                                  final session = _sessions[index];
                                  return SessionCard(
                                    session: session,
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => SessionDetailScreen(sessionId: session.id),
                                        ),
                                      );
                                      _loadSessions();
                                    },
                                  ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.1);
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
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF7C5CFC).withOpacity(0.06),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .move(begin: const Offset(0, 0), end: const Offset(-80, 150), duration: 25.seconds),
        ),
        Positioned(
          bottom: -100,
          left: -150,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFF8C42).withOpacity(0.05),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .move(begin: const Offset(0, 0), end: const Offset(100, -80), duration: 20.seconds),
        ),
      ],
    );
  }
}
