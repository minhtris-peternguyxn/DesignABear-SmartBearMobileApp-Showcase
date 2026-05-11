import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserInfoCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final bool isPro;

  const UserInfoCard({
    super.key,
    required this.user,
    required this.isPro,
  });

  @override
  Widget build(BuildContext context) {
    final name = user['name'] as String? ?? 
                 user['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name'] as String? ??
                 user['unique_name'] as String? ??
                 'Người dùng';
    final email = user['email'] as String? ?? 
                  user['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'] as String? ??
                  '';
    final primaryColor = Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, const Color(0xFF7C5CFC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'U',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1A1A2E),
                    height: 1.2,
                  ),
                ),
                if (email.isNotEmpty)
                  Text(
                    email,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                      height: 1.4,
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
