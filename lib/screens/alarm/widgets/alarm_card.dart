import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../data/models/response/alarm_response.dart';

class AlarmCard extends StatelessWidget {
  final AlarmModel alarm;
  final Function(bool) onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const AlarmCard({
    super.key,
    required this.alarm,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = alarm.isEnabled;
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(isEnabled ? 0.6 : 0.3),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: isEnabled ? Colors.white.withOpacity(0.5) : Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A2E).withOpacity(isEnabled ? 0.06 : 0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onEdit,
            onLongPress: onDelete,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  // Time Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alarm.time,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF1A1A2E).withOpacity(isEnabled ? 1.0 : 0.4),
                            letterSpacing: -1.0,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              alarm.useVoice ? Icons.record_voice_over_rounded : Icons.music_note_rounded,
                              size: 14,
                              color: isEnabled ? primaryColor : Colors.grey[400],
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                alarm.useVoice ? 'Giọng Gấu' : 'Nhạc chuông',
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isEnabled ? primaryColor.withOpacity(0.7) : Colors.grey[400],
                                ),
                              ),
                            ),
                            if (alarm.repeatCount > 1) ...[
                              Text(' • ', style: TextStyle(color: Colors.grey[300])),
                              Text(
                                'Lặp ${alarm.repeatCount} lần',
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Action Section
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: onDelete,
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                        icon: Icon(Icons.delete_outline_rounded, 
                          size: 20, 
                          color: Colors.red[300]?.withOpacity(isEnabled ? 0.6 : 0.3)
                        ),
                      ),
                      const SizedBox(width: 4),
                      Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: isEnabled,
                          onChanged: onToggle,
                          activeColor: primaryColor,
                          activeTrackColor: primaryColor.withOpacity(0.2),
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey[200],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0);
  }
}
