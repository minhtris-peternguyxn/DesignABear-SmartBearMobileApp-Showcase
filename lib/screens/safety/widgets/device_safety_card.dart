import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../data/models/response/device_model.dart';

class DeviceSafetyCard extends StatelessWidget {
  final DeviceModel device;
  final Function(int) onUpdateMode;
  final Function(String) onAddTopic;
  final Function(String) onRemoveTopic;

  const DeviceSafetyCard({
    super.key,
    required this.device,
    required this.onUpdateMode,
    required this.onAddTopic,
    required this.onRemoveTopic,
  });

  @override
  Widget build(BuildContext context) {
    final profileName = device.profileName ?? 'Chưa đặt tên';

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A2E).withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: ExpansionTile(
          shape: const RoundedRectangleBorder(side: BorderSide.none),
          collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
          backgroundColor: Theme.of(context).cardColor.withOpacity(0.3),
          trailing: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey[400]),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF17409A), Color(0xFF7C5CFC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7C5CFC).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: const Icon(Icons.child_care_rounded, color: Colors.white, size: 22),
          ),
          title: Text(
            profileName, 
            style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, fontSize: 18, color: Theme.of(context).textTheme.titleLarge?.color, height: 1.4),
          ),
          subtitle: Text(
            'Gấu con: ${device.nickname ?? device.serialNumber}', 
            style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w500, height: 1.4),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(color: Colors.black12, height: 1),
            ),
            const SizedBox(height: 16),
            
            Text(
              'PHẢN ỨNG KHI GẶP NỘI DUNG NHẠY CẢM:', 
              style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5),
            ),
            const SizedBox(height: 14),
            _buildGlassTinyModeOption(
              context,
              modeId: 1, 
              title: 'Giả vờ không nghe rõ',
              subtitle: 'Gấu sẽ lảng tránh thông minh: "Hả? Bé nói gì Gấu nghe không rõ?"',
              icon: Icons.hearing_disabled_rounded,
            ),
            const SizedBox(height: 12),
            _buildGlassTinyModeOption(
              context,
              modeId: 2, 
              title: 'Nhắc nhở nhẹ nhàng',
              subtitle: 'Gấu sẽ gợi ý tích cực: "Bé ơi, mình nói chuyện khác vui hơn nhé!"',
              icon: Icons.tips_and_updates_rounded,
            ),
            
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CHỦ ĐỀ CHẶN RIÊNG:', 
                  style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                ),
                GestureDetector(
                  onTap: () => _showAddTopicDialog(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8C42).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.add_rounded, size: 14, color: Color(0xFFFF8C42)),
                        const SizedBox(width: 4),
                        Text(
                          'THÊM', 
                          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFFFF8C42)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildGlassTopicChips(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassTinyModeOption(
    BuildContext context, {
    required int modeId, 
    required String title, 
    required String subtitle,
    required IconData icon,
  }) {
    bool isSelected = (device.safetyResponseMode ?? 2) == modeId;
    final primaryColor = const Color(0xFF17409A);

    return InkWell(
      onTap: () => onUpdateMode(modeId),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).cardColor : Theme.of(context).cardColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primaryColor.withOpacity(0.3) : Colors.white.withOpacity(0.4),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: primaryColor.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ] : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor.withOpacity(0.1) : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: isSelected ? primaryColor : Colors.grey[400]),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, 
                    style: GoogleFonts.fredoka(
                      color: isSelected ? primaryColor : Theme.of(context).textTheme.bodyLarge?.color, 
                      fontSize: 15, 
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle, 
                    style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: primaryColor, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassTopicChips(BuildContext context) {
    List<String> topics = device.blockedTopics ?? [];
    if (topics.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            'Chưa chặn chủ đề riêng nào.', 
            style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 11, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: topics.map((t) => Container(
        padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFF8C42).withOpacity(0.08),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: const Color(0xFFFF8C42).withOpacity(0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              t, 
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => onRemoveTopic(t),
              child: Icon(Icons.cancel_rounded, size: 16, color: const Color(0xFFFF8C42).withOpacity(0.4)),
            ),
          ],
        ),
      )).toList(),
    );
  }

  void _showAddTopicDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        surfaceTintColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text(
          'Chặn chủ đề cho ${device.profileName ?? 'Chưa đặt tên'}',
          style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Gấu sẽ lảng tránh câu hỏi liên quan đến chủ đề này.',
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              autofocus: true,
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: 'VD: Nhện, Phim ma, Bóng tối...',
                hintStyle: GoogleFonts.inter(color: Colors.grey[400], fontSize: 14),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), 
            child: Text('HỦY', style: GoogleFonts.inter(fontWeight: FontWeight.w800, color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              final topic = controller.text.trim();
              if (topic.isNotEmpty) {
                onAddTopic(topic);
                Navigator.pop(ctx);
              }
            },
            child: Text('THÊM NGAY', style: GoogleFonts.inter(fontWeight: FontWeight.w800, color: const Color(0xFF17409A))),
          ),
        ],
      ),
    );
  }
}
