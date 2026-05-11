import 'package:flutter/material.dart';

class EmptyDeviceView extends StatelessWidget {
  final String displayName;

  const EmptyDeviceView({super.key, required this.displayName});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pets_rounded, size: 80, color: colorScheme.primary.withOpacity(0.2)),
          const SizedBox(height: 24),
          Text('Chào $displayName!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Text('Bạn chưa có chú Gấu nào. Hãy kết nối ngay nhé!',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
