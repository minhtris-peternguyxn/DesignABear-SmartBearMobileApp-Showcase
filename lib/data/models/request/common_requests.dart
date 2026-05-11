class AlarmRequest {
  final String? time;
  final String? label;
  final List<int>? days;
  final bool? isEnabled;
  final String? deviceId;
  final int? hour;
  final int? minute;
  final bool? useVoice;
  final String? wakeUpMessage;
  final String? audioUrl;
  final int? repeatCount;
  final String? repeatMode;

  AlarmRequest({
    this.time,
    this.label,
    this.days,
    this.isEnabled,
    this.deviceId,
    this.hour,
    this.minute,
    this.useVoice,
    this.wakeUpMessage,
    this.audioUrl,
    this.repeatCount,
    this.repeatMode,
  });

  Map<String, dynamic> toJson() {
    return {
      if (deviceId != null) 'DeviceId': deviceId,
      if (hour != null) 'Hour': hour,
      if (minute != null) 'Minute': minute,
      if (label != null) 'Label': label,
      if (isEnabled != null) 'IsEnabled': isEnabled,
      if (useVoice != null) 'UseVoice': useVoice,
      if (wakeUpMessage != null) 'WakeUpMessage': wakeUpMessage,
      if (audioUrl != null) 'AudioUrl': audioUrl,
      if (repeatCount != null) 'RepeatCount': repeatCount,
      if (repeatMode != null) 'RepeatMode': repeatMode,
    };
  }
}

class AddBannedWordRequest {
  final String word;
  final String category;
  final bool isGlobal;

  AddBannedWordRequest({
    required this.word, 
    this.category = 'personal',
    this.isGlobal = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'category': category,
      'isGlobal': isGlobal,
    };
  }
}
