class VoiceModel {
  final String voiceId;
  final String name;
  final String provider;
  final bool isPremium;
  final String? previewUrl;
  final String? description;

  VoiceModel({
    required this.voiceId,
    required this.name,
    required this.provider,
    this.isPremium = false,
    this.previewUrl,
    this.description,
  });

  factory VoiceModel.fromJson(Map<String, dynamic> json) {
    return VoiceModel(
      voiceId: json['voiceId'] ?? json['id'] ?? '',
      name: json['name'] ?? 'Không tên',
      provider: json['provider'] ?? 'Unknown',
      isPremium: json['isPremium'] ?? false,
      previewUrl: json['previewUrl'],
      description: json['description'],
    );
  }
}
