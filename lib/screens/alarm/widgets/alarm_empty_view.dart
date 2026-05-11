import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlarmEmptyView extends StatelessWidget {
  final VoidCallback onAdd;

  const AlarmEmptyView({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.4)),
            ),
            child: Icon(Icons.alarm_off_rounded, size: 64, color: Colors.grey[400]),
          ),
          const SizedBox(height: 32),
          Text(
            'Chưa có báo thức',
            style: GoogleFonts.beVietnamPro(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Hãy đặt báo thức bằng giọng Gấu để\nbé thức dậy mỗi ngày trong niềm vui nhé!',
            textAlign: TextAlign.center,
            style: GoogleFonts.beVietnamPro(
              fontSize: 15,
              color: Colors.grey[500],
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Tạo báo thức ngay'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ],
      ),
    );
  }
}
