import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../data/models/response/safety_response.dart';
import 'banned_word_tile.dart';

class BannedWordList extends StatelessWidget {
  final List<BannedWordModel> bannedWords;
  final Map<String, String> categoryLabels;
  final Map<String, Color> categoryColors;
  final Function(int) onDelete;

  const BannedWordList({
    super.key,
    required this.bannedWords,
    required this.categoryLabels,
    required this.categoryColors,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final personalWords = bannedWords.where((w) => w.userId != null).toList();
    final systemWords = bannedWords.where((w) => w.userId == null).toList();

    if (personalWords.isEmpty && systemWords.isEmpty) {
      return Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_fix_high_rounded, color: Colors.grey[300], size: 32),
            const SizedBox(height: 12),
            Text(
              'Chưa có từ khóa nào bị chặn.', 
              style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        ...personalWords.map((w) => BannedWordTile(
          word: w, 
          isPersonal: true, 
          categoryLabels: categoryLabels, 
          categoryColors: categoryColors, 
          onDelete: () => onDelete(w.id),
        )),
        if (personalWords.isNotEmpty && systemWords.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(child: Divider(color: Theme.of(context).dividerColor.withOpacity(0.1))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('HỆ THỐNG', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey[400], fontWeight: FontWeight.w800, letterSpacing: 1.0)),
                ),
                Expanded(child: Divider(color: Theme.of(context).dividerColor.withOpacity(0.1))),
              ],
            ),
          ),
        ...systemWords.map((w) => BannedWordTile(
          word: w, 
          isPersonal: false, 
          categoryLabels: categoryLabels, 
          categoryColors: categoryColors, 
          onDelete: () {}, // System words can't be deleted here
        )),
      ],
    );
  }
}
