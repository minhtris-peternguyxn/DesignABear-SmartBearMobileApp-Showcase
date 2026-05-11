import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryHeader extends StatelessWidget {
  final String profileName;
  final VoidCallback onBack;
  final VoidCallback onRefresh;

  const HistoryHeader({
    super.key,
    required this.profileName,
    required this.onBack,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back_rounded, size: 22, color: Color(0xFF1A1A2E)),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LỊCH SỬ',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).primaryColor.withOpacity(0.4),
                    letterSpacing: 2.0,
                    height: 1.4,
                  ),
                ),
                Text(
                  profileName,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1A1A2E),
                    letterSpacing: -0.5,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRefresh,
            icon: Icon(Icons.refresh_rounded, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
