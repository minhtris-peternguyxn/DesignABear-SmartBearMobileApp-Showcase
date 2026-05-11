class SubscriptionStatusModel {
  final bool isPro;
  final String? preferredVoiceId;
  final DateTime? expiredAt;
  final int smartCandies;
  final DateTime? proExpiresAt; // For better compatibility
  final String? planName;

  SubscriptionStatusModel({
    required this.isPro,
    this.preferredVoiceId,
    this.expiredAt,
    this.smartCandies = 0,
    this.proExpiresAt,
    this.planName,
  });

  factory SubscriptionStatusModel.fromJson(Map<String, dynamic> json) {
    final exp = json['expiredAt'] != null || json['proExpiresAt'] != null
        ? DateTime.parse(json['expiredAt'] ?? json['proExpiresAt']).toLocal() 
        : null;
    return SubscriptionStatusModel(
      isPro: json['isPro'] ?? false,
      preferredVoiceId: json['preferredVoiceId'],
      expiredAt: exp,
      proExpiresAt: exp,
      smartCandies: json['smartCandies'] ?? 0,
      planName: json['planName'],
    );
  }
}

class PaymentQRResponse {
  final String checkoutUrl;
  final String? qrCode;
  final String? paymentId;

  PaymentQRResponse({
    required this.checkoutUrl,
    this.qrCode,
    this.paymentId,
  });

  factory PaymentQRResponse.fromJson(Map<String, dynamic> json) {
    return PaymentQRResponse(
      checkoutUrl: json['checkoutUrl'] ?? '',
      qrCode: json['qrCode'],
      paymentId: json['paymentId'],
    );
  }
}

class SubscriptionPlanModel {
  final int id;
  final String name;
  final int price;
  final String description;
  final String planType;
  final int priceMonthly;

  SubscriptionPlanModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.planType,
    required this.priceMonthly,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      description: json['description'] ?? '',
      planType: json['planType'] ?? '',
      priceMonthly: json['priceMonthly'] ?? json['price'] ?? 0,
    );
  }
}
