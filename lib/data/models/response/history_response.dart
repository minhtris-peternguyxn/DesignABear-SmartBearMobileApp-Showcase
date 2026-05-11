class ChatSessionModel {
  final String id;
  final DateTime startTime;
  final bool isActive;
  final String? profileId;
  final String? category;
  final String? title;
  final String? summary;
  final int? interactionCount;

  ChatSessionModel({
    required this.id,
    required this.startTime,
    required this.isActive,
    this.profileId,
    this.category,
    this.title,
    this.summary,
    this.interactionCount,
  });

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) {
    return ChatSessionModel(
      id: json['id'] ?? '',
      startTime: json['startTime'] != null 
          ? DateTime.parse(json['startTime']).toLocal() 
          : DateTime.now(),
      isActive: json['isActive'] ?? false,
      profileId: json['profileId'],
      category: json['category'],
      title: json['title'],
      summary: json['summary'],
      interactionCount: json['interactionCount'],
    );
  }
}

class ChatInteractionModel {
  final String request;
  final String response;
  final DateTime timestamp;
  final bool isSafe;
  final String? safetyViolationCategory;

  ChatInteractionModel({
    required this.request,
    required this.response,
    required this.timestamp,
    required this.isSafe,
    this.safetyViolationCategory,
  });

  factory ChatInteractionModel.fromJson(Map<String, dynamic> json) {
    return ChatInteractionModel(
      request: json['request'] ?? '',
      response: json['response'] ?? '',
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp']).toLocal() 
          : DateTime.now(),
      isSafe: json['isSafe'] ?? true,
      safetyViolationCategory: json['safetyViolationCategory'],
    );
  }
}

class SessionDetailModel {
  final String id;
  final String? title;
  final String? summary;
  final List<ChatInteractionModel> interactions;

  SessionDetailModel({
    required this.id,
    this.title,
    this.summary,
    required this.interactions,
  });

  factory SessionDetailModel.fromJson(Map<String, dynamic> json) {
    return SessionDetailModel(
      id: json['id'] ?? '',
      title: json['title'],
      summary: json['summary'],
      interactions: (json['interactions'] as List? ?? [])
          .map((i) => ChatInteractionModel.fromJson(i))
          .toList(),
    );
  }
}
