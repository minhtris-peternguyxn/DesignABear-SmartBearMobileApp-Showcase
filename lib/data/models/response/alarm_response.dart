class AlarmModel {
  final String alarmId;
  final String time;
  final String? label;
  final List<int> days;
  final bool isEnabled;
  final String deviceId;
  final bool useVoice;
  final String? wakeUpMessage;
  final String? audioUrl;
  final int repeatCount;

  AlarmModel({
    required this.alarmId,
    required this.time,
    this.label,
    required this.days,
    required this.isEnabled,
    required this.deviceId,
    this.useVoice = false,
    this.wakeUpMessage,
    this.audioUrl,
    this.repeatCount = 1,
  });

  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    // Construct time string "HH:mm" from hour and minute fields
    final int h = json['hour'] ?? json['Hour'] ?? 7;
    final int m = json['minute'] ?? json['Minute'] ?? 0;
    final String timeStr = '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';

    return AlarmModel(
      alarmId: json['alarmId']?.toString() ?? json['id']?.toString() ?? json['AlarmId']?.toString() ?? '',
      time: timeStr,
      label: json['label'] ?? json['Label'],
      days: (json['days'] as List? ?? []).cast<int>(),
      isEnabled: json['isEnabled'] ?? json['isActive'] ?? json['IsEnabled'] ?? true,
      deviceId: json['deviceId'] ?? json['DeviceId'] ?? '',
      useVoice: json['useVoice'] ?? json['UseVoice'] ?? false,
      wakeUpMessage: json['wakeUpMessage'] ?? json['WakeUpMessage'],
      audioUrl: json['audioUrl'] ?? json['AudioUrl'],
      repeatCount: json['repeatCount'] ?? json['RepeatCount'] ?? 1,
    );
  }
}
