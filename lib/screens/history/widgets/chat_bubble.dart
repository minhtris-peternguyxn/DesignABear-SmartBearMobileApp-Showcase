import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/response/history_response.dart';

class ChatBubble extends StatelessWidget {
  final ChatInteractionModel item;

  const ChatBubble({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('HH:mm').format(item.timestamp);
    final isUnsafe = item.isSafe == false;

    return Column(
      children: [
        // Child Message (Right aligned, Purple Glass)
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isUnsafe 
                  ? Colors.redAccent.withOpacity(0.15) 
                  : const Color(0xFF7C5CFC).withOpacity(0.15),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(4),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              border: Border.all(
                color: isUnsafe 
                    ? Colors.redAccent.withOpacity(0.3) 
                    : const Color(0xFF7C5CFC).withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isUnsafe)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.warning_amber_rounded, size: 12, color: Colors.redAccent),
                        const SizedBox(width: 4),
                        Text(
                          'Nội dung bị chặn: ${item.safetyViolationCategory}', 
                          style: GoogleFonts.inter(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                Text(
                  item.request,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1A1A2E), 
                    fontSize: 14, 
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeStr, 
                  style: GoogleFonts.inter(color: Colors.grey.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),

        // Bear Response (Left aligned, White Glass)
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              border: Border.all(color: Colors.white.withOpacity(0.4)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.smart_toy_rounded, size: 14, color: Color(0xFF4ECDC4)),
                    const SizedBox(width: 6),
                    Text(
                      'SMARTBEAR', 
                      style: GoogleFonts.inter(color: const Color(0xFF4ECDC4), fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.response,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1A1A2E), 
                    fontSize: 14, 
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
