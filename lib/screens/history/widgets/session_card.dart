import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/response/history_response.dart';

class SessionCard extends StatelessWidget {
  final ChatSessionModel session;
  final VoidCallback onTap;

  const SessionCard({
    super.key,
    required this.session,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final startTime = session.startTime;
    final dateStr = DateFormat('dd/MM/yyyy').format(startTime);
    final timeStr = DateFormat('HH:mm').format(startTime);
    final isActive = session.isActive;
    final category = session.category ?? 'Trò chuyện';
    
    final categoryColor = _getPastelCategoryColor(category);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A2E).withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        category.toUpperCase(),
                        style: GoogleFonts.beVietnamPro(
                          color: categoryColor, 
                          fontSize: 10, 
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$dateStr • $timeStr', 
                      style: GoogleFonts.beVietnamPro(color: Colors.grey[400], fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                    if (isActive) ...[
                      const SizedBox(width: 10),
                      _buildPulseIndicator(),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  session.title ?? 'Phiên trò chuyện',
                  style: GoogleFonts.beVietnamPro(
                    color: const Color(0xFF1A1A2E), 
                    fontSize: 19, 
                    fontWeight: FontWeight.w800,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  session.summary ?? (isActive ? 'Gấu và bé đang nói chuyện...' : 'Đang tóm tắt...'),
                  style: GoogleFonts.beVietnamPro(
                    color: const Color(0xFF1A1A2E).withOpacity(0.6), 
                    fontSize: 14, 
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.chat_bubble_outline_rounded, size: 16, color: Colors.grey[300]),
                    const SizedBox(width: 6),
                    Text(
                      'Tóm tắt phiên', 
                      style: GoogleFonts.beVietnamPro(color: Colors.grey[400], fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    Text(
                      'Xem chi tiết', 
                      style: GoogleFonts.beVietnamPro(color: const Color(0xFF7C5CFC), fontSize: 12, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: Color(0xFF7C5CFC)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPulseIndicator() {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Color(0xFF4ECDC4),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Color(0xFF4ECDC4), blurRadius: 4, spreadRadius: 1),
        ],
      ),
    );
  }

  Color _getPastelCategoryColor(String category) {
    switch (category) {
      case 'Học tập': return const Color(0xFF42A5F5); // Pastel Blue
      case 'Kể chuyện': return const Color(0xFFFFA726); // Pastel Orange
      case 'Giải trí': return const Color(0xFFF06292); // Pastel Pink
      case 'Hỏi đáp': return const Color(0xFF66BB6A); // Pastel Green
      default: return const Color(0xFFAB47BC); // Pastel Purple
    }
  }
}
