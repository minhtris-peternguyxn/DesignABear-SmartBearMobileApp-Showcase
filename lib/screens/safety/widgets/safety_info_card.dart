import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SafetyInfoCard extends StatelessWidget {
  const SafetyInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF7C5CFC).withOpacity(0.1),
            const Color(0xFF17409A).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C5CFC).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: Color(0xFF7C5CFC), size: 18),
              ),
              const SizedBox(width: 14),
              Text(
                'Bảo vệ AI Đa tầng', 
                style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w700, fontSize: 18, color: Theme.of(context).textTheme.titleLarge?.color, height: 1.4),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Hệ thống sử dụng AI thời gian thực để phân tích ngữ cảnh. Mọi nội dung bé hỏi và Gấu trả lời đều được lọc qua 2 lớp bảo vệ để đảm bảo môi trường phát triển lành mạnh nhất.',
            style: GoogleFonts.beVietnamPro(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7), fontSize: 13, height: 1.6, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
