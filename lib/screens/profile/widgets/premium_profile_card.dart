import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PremiumProfileCard extends StatelessWidget {
  final List<Widget> children;
  final String? title;

  const PremiumProfileCard({
    super.key,
    required this.children,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final cardColor = Theme.of(context).cardTheme.color ?? Colors.white;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 12),
                child: Text(
                  title!.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white54 : const Color(0xFF94A3B8),
                    letterSpacing: 2.0,
                  ),
                ),
              ).animate().fadeIn().slideX(begin: -0.1),
            ],
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: cardColor.withOpacity(isDark ? 0.8 : 0.5),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: cardColor.withOpacity(isDark ? 0.3 : 0.8),
                  width: 2,
                ),
                gradient: LinearGradient(
                  colors: [
                    cardColor.withOpacity(isDark ? 0.9 : 0.7),
                    cardColor.withOpacity(isDark ? 0.7 : 0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7C5CFC).withOpacity(0.05),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Column(
                children: _buildChildrenWithDividers(),
              ),
            ),
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.05),
      ],
    );
  }

  List<Widget> _buildChildrenWithDividers() {
    if (children.isEmpty) return [];
    
    List<Widget> result = [];
    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.white.withOpacity(0.5),
            indent: 24,
            endIndent: 24,
          ),
        );
      }
    }
    return result;
  }
}
