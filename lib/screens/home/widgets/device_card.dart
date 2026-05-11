import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../history/history_screen.dart';
import '../../profile/bear_profile_screen.dart';

class DeviceCard extends StatelessWidget {
  final Map<String, dynamic> device;
  final VoidCallback onDeviceUpdated;

  const DeviceCard({
    super.key,
    required this.device,
    required this.onDeviceUpdated,
  });

  String _formatCount(dynamic raw) {
    final n = (raw is int) ? raw : (int.tryParse(raw.toString()) ?? 0);
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(n % 1000000 == 0 ? 0 : 1)}tr';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}k';
    return n.toString();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final nickname = device['nickname'] as String? ?? 'Gấu SmartBear';
    final status = device['status'] as String? ?? 'Unknown';
    final profileName = device['profileName'] as String?;
    final isProtected = device['isHardwareProtectionEnabled'] as bool? ?? false;
    final isActive = status == 'Active' || status == 'Online';
    final dailyCandies = device['dailyCandyBalance'] ?? 0;
    final purchasedCandies = device['purchasedCandies'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF17409A).withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: InkWell(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BearProfileScreen(device: device)),
            );
            if (result == true) onDeviceUpdated();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upper Section
              Padding(
                padding: const EdgeInsets.all(28),
                child: Row(
                  children: [
                    // Premium Avatar Block (Vibrant Gradient)
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isActive
                              ? [const Color(0xFF17409A), const Color(0xFF7C5CFC)] // Navy to Purple
                              : [const Color(0xFFBDBDBD), const Color(0xFFE0E0E0)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                        image: device['profileImageUrl'] != null && device['profileImageUrl'].toString().isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(device['profileImageUrl'].toString()),
                                fit: BoxFit.cover,
                              )
                            : null,
                        boxShadow: isActive ? [
                          BoxShadow(
                            color: const Color(0xFF7C5CFC).withOpacity(0.25),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          )
                        ] : [],
                      ),
                      child: device['profileImageUrl'] != null && device['profileImageUrl'].toString().isNotEmpty
                          ? null
                          : const Icon(Icons.pets_rounded, color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nickname,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.beVietnamPro(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF1A1A1E),
                              letterSpacing: -0.2,
                              height: 1.2,
                            ),
                          ),
                          if (profileName != null)
                            Container(
                              margin: const EdgeInsets.only(top: 6, bottom: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7C5CFC).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFF7C5CFC).withOpacity(0.2)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.face_rounded, size: 14, color: Color(0xFF7C5CFC)),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      'Hồ sơ của $profileName',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.beVietnamPro(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        color: const Color(0xFF7C5CFC),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 2),
                          _buildStatusIndicator(isActive),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFFBDBDBD)),
                  ],
                ),
              ),

              // Info Dashboard Row (Unified)
              if (device['profileId'] != null)
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.white.withOpacity(0.05) 
                      : const Color(0xFFF8F9FE),
                    borderRadius: BorderRadius.circular(24),
                  ),
                   child: Row(
                    children: [
                      _buildInfoItem(context, Icons.cookie_rounded, '${_formatCount(dailyCandies)} Daily', const Color(0xFFFF6B9D)),
                      const SizedBox(width: 16),
                      _buildInfoItem(context, Icons.stars_rounded, '${_formatCount(purchasedCandies)} VIP', const Color(0xFFFF8C42)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _showCandyInfo(context),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.info_outline_rounded, size: 16, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HistoryScreen(profile: {
                              'id': device['profileId'],
                              'name': profileName ?? 'Bạn Gấu',
                            }),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.history_rounded, size: 20, color: colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ),

              // Bottom Spacer
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          value,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : const Color(0xFF1A1A1E),
          ),
        ),
      ],
    );
  }

  void _showCandyInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1A1A1E) : Colors.white,
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        title: Text(
          'Thông tin về Kẹo',
          style: GoogleFonts.beVietnamPro(
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCandyExplanationItem(
              context,
              Icons.cookie_rounded,
              const Color(0xFFFF6B9D),
              'Kẹo Daily',
              'Kẹo miễn phí được cấp hàng ngày theo gói của bạn. Kẹo này sẽ hết hạn vào cuối ngày và được cấp mới vào sáng hôm sau.',
            ),
            const SizedBox(height: 24),
            _buildCandyExplanationItem(
              context,
              Icons.stars_rounded,
              const Color(0xFFFF8C42),
              'Kẹo VIP',
              'Kẹo tích lũy khi bạn mua thêm hoặc được tặng. Kẹo này không bao giờ hết hạn và chỉ được sử dụng sau khi bạn đã dùng hết kẹo Daily.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Đã hiểu',
              style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF17409A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCandyExplanationItem(BuildContext context, IconData icon, Color color, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.beVietnamPro(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF1A1A1E),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 13,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white60 : Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator(bool isActive) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF4ECDC4) : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          isActive ? 'TRỰC TUYẾN' : 'NGOẠI TUYẾN',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isActive ? const Color(0xFF4ECDC4) : Colors.grey,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}
