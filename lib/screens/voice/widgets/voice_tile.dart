import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../data/models/response/voice_response.dart';

class VoiceTile extends StatelessWidget {
  final VoiceModel voice;
  final bool isSelected;
  final bool locked;
  final bool isPlaying;
  final VoidCallback onTap;
  final VoidCallback onPlayPreview;

  const VoiceTile({
    super.key,
    required this.voice,
    required this.isSelected,
    required this.locked,
    required this.isPlaying,
    required this.onTap,
    required this.onPlayPreview,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = isSelected ? colorScheme.primary : (locked ? Colors.amber : Colors.grey[400]);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(isSelected ? 0.8 : 0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? colorScheme.primary.withOpacity(0.5) : Colors.white.withOpacity(0.3),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected ? colorScheme.primary.withOpacity(0.1) : Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // Icon Section
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: isSelected ? colorScheme.primary.withOpacity(0.1) : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected ? [
                        BoxShadow(color: colorScheme.primary.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))
                      ] : [],
                    ),
                    child: Icon(
                      locked ? Icons.lock_outline_rounded : (isSelected ? Icons.check_circle_rounded : Icons.multitrack_audio_rounded),
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Info Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          voice.name,
                          style: GoogleFonts.beVietnamPro(
                            color: locked ? Colors.grey[400] : const Color(0xFF1A1A2E),
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          voice.description ?? 'Giọng nói AI chất lượng cao.',
                          style: GoogleFonts.beVietnamPro(
                            color: Colors.grey[500],
                            fontSize: 12,
                            height: 1.3,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  
                  // Action Section: Preview Button
                  if (voice.previewUrl != null && !locked)
                    GestureDetector(
                      onTap: () {
                        // Prevent ListTile onTap when clicking the play button
                        onPlayPreview();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isPlaying ? colorScheme.primary : Colors.white.withOpacity(0.6),
                          shape: BoxShape.circle,
                          border: Border.all(color: isPlaying ? colorScheme.primary : Colors.grey[200]!),
                        ),
                        child: Icon(
                          isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
                          color: isPlaying ? Colors.white : colorScheme.primary,
                          size: 18,
                        ),
                      ).animate(target: isPlaying ? 1 : 0).scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 200.ms, curve: Curves.easeOutBack),
                    )
                  else if (locked)
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }
}
