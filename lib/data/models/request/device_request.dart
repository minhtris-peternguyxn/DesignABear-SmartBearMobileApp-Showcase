class PairDeviceRequest {
  final String serialNumber;
  final String? nickname;

  PairDeviceRequest({required this.serialNumber, this.nickname});

  Map<String, dynamic> toJson() {
    return {
      'serialNumber': serialNumber,
      if (nickname != null) 'nickname': nickname,
    };
  }
}

class ClaimDeviceRequest {
  final String code;
  final String? nickname;
  final String? childName;

  ClaimDeviceRequest({required this.code, this.nickname, this.childName});

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      if (nickname != null) 'nickname': nickname,
      if (childName != null) 'childName': childName,
    };
  }
}

class RequestOtpRequest {
  final String serialNumber;

  RequestOtpRequest({required this.serialNumber});

  Map<String, dynamic> toJson() {
    return {
      'serialNumber': serialNumber,
    };
  }
}

class ToggleProtectionRequest {
  final bool isEnabled;

  ToggleProtectionRequest({required this.isEnabled});

  Map<String, dynamic> toJson() {
    return {
      'isEnabled': isEnabled,
    };
  }
}
