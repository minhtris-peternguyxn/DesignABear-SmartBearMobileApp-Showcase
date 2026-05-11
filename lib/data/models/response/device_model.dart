class DeviceModel {
  final String deviceId;
  final String? serialNumber;
  final String? nickname;
  final String? status;
  final String? profileName;
  final String? currentMode;
  final String? profileId;

  // Candy system & Safety
  final int? dailyCandyBalance;
  final int? purchasedCandies;
  final String? remainingCandiesDisplay;
  final List<String>? blockedTopics;
  final int? safetyResponseMode;

  // Personalization
  final String? gender;
  final int? age;
  final String? honorific;
  final String? personality;
  final String? personalityDescription;
  final String? preferredVoiceId;
  final String? preferredTtsProvider;
  final String? safetyPretendMessage;
  final String? safetyWarningMessage;
  final String? bearName;
  final String? profileImageUrl;
  final int? creativityLevel;
  final int? emotionLevel;
  final int? energyLevel;
  final int? complexityLevel;

  DeviceModel({
    required this.deviceId,
    this.serialNumber,
    this.nickname,
    this.status,
    this.profileName,
    this.currentMode,
    this.profileId,
    this.dailyCandyBalance,
    this.purchasedCandies,
    this.remainingCandiesDisplay,
    this.blockedTopics,
    this.safetyResponseMode,
    this.gender,
    this.age,
    this.honorific,
    this.personality,
    this.personalityDescription,
    this.preferredVoiceId,
    this.preferredTtsProvider,
    this.safetyPretendMessage,
    this.safetyWarningMessage,
    this.bearName,
    this.profileImageUrl,
    this.creativityLevel,
    this.emotionLevel,
    this.energyLevel,
    this.complexityLevel,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      deviceId: json['deviceId']?.toString() ?? json['id']?.toString() ?? '',
      serialNumber: json['serialNumber']?.toString(),
      nickname: json['nickname']?.toString(),
      status: json['status']?.toString(),
      profileName: json['profileName']?.toString(),
      currentMode: json['currentMode']?.toString(),
      profileId: json['profileId']?.toString(),
      dailyCandyBalance: json['dailyCandyBalance'] as int?,
      purchasedCandies: json['purchasedCandies'] as int?,
      remainingCandiesDisplay: json['remainingCandiesDisplay']?.toString(),
      blockedTopics: (json['blockedTopics'] as List?)?.map((e) => e.toString()).toList(),
      safetyResponseMode: json['safetyResponseMode'] as int?,
      gender: json['gender']?.toString(),
      age: json['age'] as int?,
      honorific: json['honorific']?.toString(),
      personality: json['personality']?.toString(),
      personalityDescription: json['personalityDescription']?.toString(),
      preferredVoiceId: json['preferredVoiceId']?.toString(),
      preferredTtsProvider: json['preferredTtsProvider']?.toString(),
      safetyPretendMessage: json['safetyPretendMessage']?.toString(),
      safetyWarningMessage: json['safetyWarningMessage']?.toString(),
      bearName: json['bearName']?.toString(),
      profileImageUrl: json['profileImageUrl']?.toString(),
      creativityLevel: json['creativityLevel'] as int?,
      emotionLevel: json['emotionLevel'] as int?,
      energyLevel: json['energyLevel'] as int?,
      complexityLevel: json['complexityLevel'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'serialNumber': serialNumber,
      'nickname': nickname,
      'status': status,
      'profileName': profileName,
      'currentMode': currentMode,
      'profileId': profileId,
      'dailyCandyBalance': dailyCandyBalance,
      'purchasedCandies': purchasedCandies,
      'remainingCandiesDisplay': remainingCandiesDisplay,
      'blockedTopics': blockedTopics,
      'safetyResponseMode': safetyResponseMode,
      'gender': gender,
      'age': age,
      'honorific': honorific,
      'personality': personality,
      'personalityDescription': personalityDescription,
      'preferredVoiceId': preferredVoiceId,
      'preferredTtsProvider': preferredTtsProvider,
      'safetyPretendMessage': safetyPretendMessage,
      'safetyWarningMessage': safetyWarningMessage,
      'bearName': bearName,
      'profileImageUrl': profileImageUrl,
      'creativityLevel': creativityLevel,
      'emotionLevel': emotionLevel,
      'energyLevel': energyLevel,
      'complexityLevel': complexityLevel,
    };
  }
}
