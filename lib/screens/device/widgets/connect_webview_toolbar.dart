import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConnectWebviewToolbar extends StatelessWidget {
  final String url;
  final VoidCallback onBack;
  final VoidCallback onReload;
  final VoidCallback onConfirm;
  final Color backgroundColor;
  final Color textPrimary;

  const ConnectWebviewToolbar({
    super.key,
    required this.url,
    required this.onBack,
    required this.onReload,
    required this.onConfirm,
    required this.backgroundColor,
    required this.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        border: Border(bottom: BorderSide(color: textPrimary.withOpacity(0.05))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: textPrimary, size: 20),
            onPressed: onBack,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.lock_rounded, size: 14, color: Colors.green[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      url,
                      style: GoogleFonts.firaCode(
                        color: textPrimary.withOpacity(0.5),
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: textPrimary, size: 20),
            onPressed: onReload,
          ),
          IconButton(
            icon: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 24),
            onPressed: onConfirm,
          ),
        ],
      ),
    );
  }
}
