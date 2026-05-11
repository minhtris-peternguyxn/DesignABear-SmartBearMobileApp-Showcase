import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileHeader extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSave;
  final bool isLoading;

  const ProfileHeader({
    super.key,
    required this.onBack,
    required this.onSave,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 20, 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color ?? Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5)),
                ],
              ),
              child: Icon(Icons.arrow_back_rounded, size: 22, color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cấu Hình'.toUpperCase(),
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).primaryColor.withOpacity(0.4),
                    letterSpacing: 1.0,
                    height: 1.4,
                  ),
                ),
                Text(
                  'Bạn Gấu',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).textTheme.headlineLarge?.color,
                    letterSpacing: -0.5,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
          else
            TextButton(
              onPressed: onSave,
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'LƯU', 
                style: GoogleFonts.fredoka(fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}
