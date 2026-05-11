import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/glass_dropdown.dart';

class BannedWordInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onAdd;
  final String initialCategory;
  final List<String> categories;
  final Map<String, String> categoryLabels;
  final Map<String, Color> categoryColors;
  final Function(String) onCategoryChanged;

  const BannedWordInput({
    super.key,
    required this.controller,
    required this.onAdd,
    required this.initialCategory,
    required this.categories,
    required this.categoryLabels,
    required this.categoryColors,
    required this.onCategoryChanged,
  });

  @override
  State<BannedWordInput> createState() => _BannedWordInputState();
}

class _BannedWordInputState extends State<BannedWordInput> {
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF17409A).withOpacity(0.06),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15, height: 1.4, color: Theme.of(context).textTheme.bodyLarge?.color),
                    decoration: InputDecoration(
                      hintText: 'Thêm từ khóa chặn chung...',
                      hintStyle: GoogleFonts.inter(color: Colors.grey[400], fontSize: 13, fontWeight: FontWeight.w500, height: 1.4),
                      filled: false,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    onSubmitted: (_) => widget.onAdd(),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF17409A),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF17409A).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: widget.onAdd,
                    icon: const Icon(Icons.add_rounded, color: Colors.white),
                    iconSize: 22,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Row(
              children: [
                const Icon(Icons.label_important_outline_rounded, size: 14, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Phân loại: ', 
                  style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w600, height: 1.4),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GlassDropdown<String>(
                    value: _selectedCategory,
                    items: widget.categories.map((c) => DropdownMenuItem(
                      value: c,
                      child: Text(
                        widget.categoryLabels[c] ?? c, 
                        style: GoogleFonts.inter(
                          fontSize: 12, 
                          fontWeight: FontWeight.w600, 
                          color: widget.categoryColors[c]?.withOpacity(0.8) ?? Theme.of(context).textTheme.bodyMedium?.color,
                          height: 1.4,
                        ),
                      ),
                    )).toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => _selectedCategory = v);
                        widget.onCategoryChanged(v);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
