import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../data/models/response/safety_response.dart';

class BannedWordTile extends StatelessWidget {
  final BannedWordModel word;
  final bool isPersonal;
  final Map<String, String> categoryLabels;
  final Map<String, Color> categoryColors;
  final VoidCallback onDelete;

  const BannedWordTile({
    super.key,
    required this.word,
    required this.isPersonal,
    required this.categoryLabels,
    required this.categoryColors,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final catColor = categoryColors[word.category] ?? Colors.grey;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: catColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: catColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.block_flipped, size: 14, color: catColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word.word,
                  style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 15, color: Theme.of(context).textTheme.bodyLarge?.color, height: 1.4),
                ),
                Text(
                  (categoryLabels[word.category] ?? word.category).toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 9, 
                    color: catColor,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          if (isPersonal)
            IconButton(
              onPressed: onDelete,
              icon: Icon(Icons.delete_outline_rounded, size: 18, color: Colors.grey[400]),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).cardColor,
                padding: EdgeInsets.zero,
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'CÔNG KHAI', 
                style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 8, fontWeight: FontWeight.w900),
              ),
            ),
        ],
      ),
    );
  }
}
