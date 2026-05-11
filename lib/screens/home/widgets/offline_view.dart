import 'package:flutter/material.dart';

class OfflineView extends StatelessWidget {
  final VoidCallback onRetry;

  const OfflineView({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded, size: 80, color: Colors.red[300]),
          const SizedBox(height: 24),
          const Text('Mất kết nối server',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Text('Vui lòng kiểm tra lại kết nối mạng.',
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('THỬ LẠI'),
          ),
        ],
      ),
    );
  }
}
