class BannedWordModel {
  final int id;
  final String word;
  final String category;
  final bool isActive;
  final String createdBy;
  final String? userId; // Null if system-wide
  final DateTime? createdAt;

  BannedWordModel({
    required this.id,
    required this.word,
    required this.category,
    required this.isActive,
    required this.createdBy,
    this.userId,
    this.createdAt,
  });

  factory BannedWordModel.fromJson(Map<String, dynamic> json) {
    return BannedWordModel(
      id: json['id'] ?? 0,
      word: json['word'] ?? '',
      category: json['category'] ?? 'personal',
      isActive: json['isActive'] ?? true,
      createdBy: json['createdBy'] ?? 'unknown',
      userId: json['userId']?.toString(),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']).toLocal() 
          : null,
    );
  }
}
