import 'package:flutter/material.dart';

class EmptyAlarmView extends StatelessWidget {
  const EmptyAlarmView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.alarm_off_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text('Chưa có báo thức nào', style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text('Hãy thêm báo thức để Gấu gọi bé dậy nhé!', style: TextStyle(fontSize: 14, color: Colors.grey[400])),
        ],
      ),
    );
  }
}
